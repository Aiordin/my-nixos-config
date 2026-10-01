{ ... }:
{
  # ============================================================
  # OpenSSH 服务端
  #
  # 防火墙：openFirewall 默认 true，会随 enable 自动把
  # cfg.port（默认 22）加入 networking.firewall.allowedTCPPorts，
  # 无需再改 firewall.nix。
  #
  # 主机密钥（/etc/ssh/ssh_host_*）由 sshd 首次启动时自动生成，
  # 不需要声明式管理。
  # ============================================================
  services.openssh = {
    enable = true;

    settings = {
      # 禁止 root 直接登录，统一用普通用户 kid 进入后再 sudo
      PermitRootLogin = "no";

      # 允许密码登录，方便首次接入；后续改用密钥后可设为 false
      PasswordAuthentication = true;

      # 关闭 PAM 的 keyboard-interactive 认证，避免密码走两套通道
      KbdInteractiveAuthentication = false;
    };
  };
}
