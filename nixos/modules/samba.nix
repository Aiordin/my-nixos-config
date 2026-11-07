{ lib, ... }:
let
  # 宿主机与 Windows 虚拟机互传文件的共享目录
  shareDir = "/home/kid/Share";
in
{
  # ============================================================
  # SMB 文件共享 —— 供 win10 虚拟机（virbr0 / 192.168.122.0/24）访问
  #
  # Windows 里打开资源管理器，地址栏输入：
  #     \\192.168.122.1\Share
  # 即可读写这个目录（相当于 VMware/VirtualBox 的共享文件夹）。
  #
  # 安全：只允许本机与 libvirt 虚拟机网段访问，不对局域网/公网开放。
  # ============================================================
  services.samba = {
    enable = true;
    settings = {
      global = {
        "server string" = "nixos";
        "workgroup" = "WORKGROUP";
        "server min protocol" = "SMB2";
        # 未知用户按 guest 处理 → 免密码访问共享
        "map to guest" = "Bad User";
        # 只服务本机和虚拟机网段
        "hosts allow" = "127.0.0.1 192.168.122.0/24";
        "hosts deny" = "0.0.0.0/0";
        # 不折腾打印机
        "load printers" = "no";
        "printcap name" = "/dev/null";
        "disable spoolss" = "yes";
      };

      Share = {
        path = shareDir;
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "force user" = "kid";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # 共享目录本体
  systemd.tmpfiles.rules = lib.mkAfter [
    "d ${shareDir} 0755 kid users -"
  ];

  # SMB 走 445/TCP，需要放行虚拟网桥的入站
  # （waydroid.nix 里已定义 trustedInterfaces，这里追加）
  networking.firewall.trustedInterfaces = lib.mkAfter [ "virbr0" ];
}
