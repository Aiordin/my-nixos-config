# ============================================================
# Waydroid — Android 容器
# ============================================================
# 内核侧已具备条件（无需额外内核模块）：
#   CONFIG_ANDROID_BINDER_IPC=y
#   CONFIG_ANDROID_BINDERFS=y
#   CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"
#   CONFIG_PSI=y / CONFIG_MEMFD_CREATE=y
# 因此这里只负责：容器服务 + 网络放行 + 定位 + binderfs 挂载 + 辅助工具。
# ============================================================
{ pkgs, ... }:

let
  # Waydroid 要求 binderfs 挂载在 /dev/binderfs；当前内核 /dev 下没有该挂载点，
  # waydroid-container 启动前补上（已挂载时跳过，失败也不阻塞容器启动）。
  binderfsPrepare = pkgs.writeShellScript "waydroid-binderfs-prepare" ''
    set -eu
    if [ -e /dev/binderfs ]; then
      exit 0
    fi
    mkdir -p /dev/binderfs
    ${pkgs.util-linux}/bin/mount -t binder binder /dev/binderfs
  '';
in
{
  virtualisation.waydroid = {
    enable = true;
    # 必须显式选 nftables 变体。nixpkgs 默认按 networking.nftables.enable
    #（本机 false）选 iptables 变体，而运行内核已不带 ip_tables 支持
    # （/run/booted-system/kernel-modules 下无 ip_tables.ko），
    # waydroid-net.sh 会优先调用 iptables-legacy 并失败：
    #   iptables v1.8.13 (legacy): can't initialize iptables table `filter'
    # nftables 变体让脚本改用 nft 建表，与内核的 nf_tables 一致。
    package = pkgs.waydroid-nftables;
  };

  # Waydroid 打开的地理定位（部分 App 需要）
  services.geoclue2.enable = true;

  # 图形化配置助手（Magisk / ARM 转译安装等）+ adb
  environment.systemPackages = [
    pkgs.waydroid-helper
    pkgs.android-tools
  ];

  # waydroid-helper 自带 systemd 单元（system: waydroid-mount, user: waydroid-monitor）
  systemd.packages = [ pkgs.waydroid-helper ];

  # waydroid-helper 的挂载单元随多用户目标启动
  systemd.services.waydroid-mount.wantedBy = [ "multi-user.target" ];

  # 容器启动前准备 binderfs
  systemd.services.waydroid-container.serviceConfig.ExecStartPre = [
    "-${binderfsPrepare}"
  ];

  # 网络：容器网段走 waydroid0，防火墙信任该接口
  # （virtualisation.waydroid 模块本身也会设置，这里显式写便于阅读）
  networking.firewall.trustedInterfaces = [ "waydroid0" ];
}
