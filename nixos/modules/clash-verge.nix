{ ... }:
{
  # ============================================================
  # Clash Verge Rev —— TUN 模式所需的两个特权前提
  #
  # GUI 里 TUN 模式的提示「需要安装服务模式或管理员模式」指的就是这里的
  # serviceMode：应用自身的「安装服务」按钮走 pkexec + 往 /usr/local/bin、
  # /etc/systemd/system 写文件，在 NixOS 上必然失败。正确做法是由系统
  # 声明式地提供该服务（nixpkgs 的 programs.clash-verge 模块）。
  # ============================================================
  programs.clash-verge = {
    # 安装 clash-verge-rev 到系统 profile
    enable = true;

    # 服务模式：以 root 运行 clash-verge-service（systemd 单元 clash-verge.service），
    # 由它监听 /run/clash-verge-rev/service.sock 并接受 GUI 的 IPC 请求，
    # 以特权身份启动 mihomo 内核。创建 TUN 设备、改路由、设置 DNS 都需要
    # CAP_NET_ADMIN，所以没有服务模式时 TUN 无法工作。
    serviceMode = true;

    # TUN 能力：通过 security.wrappers 生成 /run/wrappers/bin/clash-verge，
    # 带 cap_net_bind_service/cap_net_raw/cap_net_admin。
    # 缺少这些能力时，TUN 模式下的 DNS 设置不会生效。
    # 该选项同时把反向路径过滤放宽为 loose（net.ipv4.conf.*.rp_filter），
    # 这是 TUN 隧道流量所必需的。
    tunMode = true;

    # 服务套接字 /run/clash-verge-rev/service.sock 的属组，
    # 组内用户才能通过 IPC 控制内核（kid 属于 users）
    group = "users";
  };
}
