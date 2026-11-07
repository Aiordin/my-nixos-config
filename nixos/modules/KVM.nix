{ pkgs, ... }:
let
  # virtio-win ISO —— Windows 客户机的驱动安装介质，内含：
  #   · QXL 显卡驱动（qxldod）      → 解决鼠标残影 / 帧率过低
  #   · SPICE vdagent（guest agent）→ 解决剪贴板互通、分辨率自适应、鼠标集成
  # 固定到 /var/lib/libvirt/images/virtio-win.iso（符号链接，rebuild 后路径不变），
  # 方便在 virt-manager 里当作光盘挂载。
  virtioWinIso = pkgs.fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.285-1/virtio-win.iso";
    hash = "sha256-4UzyuUSSw+kl8AcLp/3+3rIEjJHuqcWlr7MCMqOXYzE=";
    name = "virtio-win-0.1.285-1.iso";
  };
in
{
# 开启 ⚙️ KVM 虚拟化支持
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  # RDP 客户端：连 Windows 客户机用。
  # Windows 的 RDP 是它自己的显示协议，桌面响应远好于 SPICE/QXL 的远程桌面路径。
  environment.systemPackages = [ pkgs.freerdp ];

  # 把 virtio-win 安装盘固定成一个稳定路径，供虚拟机光驱挂载
  systemd.tmpfiles.rules = [
    "L+ /var/lib/libvirt/images/virtio-win.iso - - - - ${virtioWinIso}"
  ];

  users.users.kid.extraGroups = [ "libvirtd" ];

  # 默认 NAT 网络（virbr0 / 192.168.122.0/24）：
  # 虚拟机经宿主机 NAT 出网，宿主机可直接访问虚拟机。
  # NixOS 的 libvirtd 模块不管理网络定义，这里用幂等 oneshot 保证
  # default 网络已定义、已启动、并设置为随系统自启（否则重启后
  # 虚拟机启动会报 "network 'default' is not active"）。
  systemd.services.libvirt-default-net = {
    description = "Ensure libvirt default NAT network is defined and started";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -euo pipefail
      virsh() { ${pkgs.libvirt}/bin/virsh -c qemu:///system "$@"; }

      if ! virsh net-info default >/dev/null 2>&1; then
        virsh net-define ${./libvirt-default-net.xml}
      fi
      virsh net-autostart default
      virsh net-start default >/dev/null 2>&1 || true
    '';
  };

  # Clash Verge / Mihomo 的 TUN 模式（auto-route）会添加
  #   ip rule 9002:  not iif lo lookup 2022      （表 2022 = default dev Mihomo）
  # 把所有非 lo 入站的流量导入 TUN，其中就包含 libvirt 虚拟机经 virbr0
  # 转发的流量 —— 后果是虚拟机断网（ICMP 不受影响，所以表现为 ping 通但
  # DNS/网页打不开）。这里在 mihomo 的规则之前插一条更高优先级的规则
  # （pref 100 < 9000），让 virbr0 的流量始终走 main 表、绕过 TUN。
  systemd.services.virbr0-bypass-mihomo-tun = {
    description = "Keep virbr0 traffic on the main routing table (bypass Mihomo TUN)";
    wantedBy = [ "multi-user.target" ];
    after = [
      "libvirtd.service"
      "libvirt-default-net.service"
    ];
    requires = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -euo pipefail
      ip=${pkgs.iproute2}/bin/ip
      # 幂等：先清掉旧的同 pref 规则，再插入
      $ip rule del pref 100 2>/dev/null || true
      $ip rule add iif virbr0 lookup main pref 100
    '';
  };
}
