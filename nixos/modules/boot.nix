{ pkgs,... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #boot.initrd.kernelModules = [ "amdgpu" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
  };

  # rtw89（Realtek RTL8852BE）WiFi：关闭省电模式与 PCIe ASPM，
  # 消除周期性延迟尖峰（表现为浏览器偶发卡顿、代理连接超时）。
  #
  # 参数名取自本内核实际导出的 /sys/module/<mod>/parameters/：
  #   rtw89_core: disable_ps_mode
  #   rtw89_pci:  disable_aspm_l1, disable_aspm_l1ss, disable_clkreq
  # 旧配置使用的 disable_lps_deep / disable_aspm / disable_ant_switch 在
  # 本内核的 rtw89 中并不存在，加载时被静默忽略
  # （journalctl -k 可见 "unknown parameter ... ignored"），等于从未生效。
  #
  # modprobe.d 会把同一模块的多行 options 合并后一并下发给内核（man 5
  # modprobe.d: "All options are added together"）；同名参数重复时由内核
  # 以最后一次赋值生效。为避免歧义，同一模块的参数统一写在一行。
  #
  # disable_ps_mode=y 会略微增加功耗、缩短续航；若更看重续航可去掉该行。
  # 若仍偶发卡顿，可再追加 rtw89_pci 的 disable_clkreq=y。
  boot.extraModprobeConfig = ''
    options rtw89_core disable_ps_mode=y
    options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss=y
  '';

  # ── 内存压缩 swap（zram）────────────────────────────────────────────
  # 背景：本机此前 swapDevices = [ ]，无任何交换空间，systemd-oomd 启动时
  # 报 "No swap; memory pressure usage will be degraded"，内存压力保护降级。
  # 本机没有磁盘 swap 分区，因此在内存里造压缩块设备（zram）作 swap：
  # 零写盘损耗，换出延迟远低于 NVMe swapfile，且 8945H（8C16T Zen4）跑
  # zstd 的吞吐绰绰有余。匿名页典型压缩比 2.5:1 ~ 4:1。
  #
  # 注：nixpkgs 26.11 起 zramSwap 由 zram-generator 后端实现，选项名不变。
  zramSwap = {
    enable = true;
    memoryPercent = 50; # 未压缩数据上限 ≈ 7.8 GiB；实际占用只等于压缩后大小
    priority = 100; # 高于任何未来的磁盘 swap，优先填 zram
    algorithm = "zstd";
  };

  # zram 场景的内核回收参数：
  #   swappiness=180    zram 在内存里，换出几乎无延迟且压缩后更省内存，鼓励换出
  #                     （上限 200；内核默认 60）
  #   page-cluster=0    每次换入 1 页（默认 3 = 8 页），避免单次缺页延迟和内存尖峰放大
  #   watermark_boost_factor=0    关掉默认 15000 的水位 boost，减少回收抖动
  #   watermark_scale_factor=125  更早唤醒 kswapd（默认 10），减少直接回收造成的卡顿
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  # zram 会被主动填到很高的使用率，而上游 oomd 默认 SwapUsedLimit=90% 且对
  # user slice 生效 ManagedOOMSwap=kill —— 不改会变成随机杀进程。故放宽到 100%。
  # enableUserSlices 默认关闭（NixOS 未跟 Fedora），桌面大户（浏览器/steam/qq）
  # 都在 user slice，这里打开。
  systemd.oomd = {
    enableUserSlices = true;
    settings.OOM = {
      SwapUsedLimit = "100%";
      DefaultMemoryPressureLimit = "60%";
      DefaultMemoryPressureDurationSec = "20s";
    };
  };

  # 注意：zram-generator 是 systemd generator，配置改动后需重启才生效
  #（模块内 restartIfChanged = false，避免运行中 swapoff 触发 OOM）；
  # 临时验证可 systemctl start systemd-zram-setup@zram0.service。
  # 另：zram 不能用于 hibernation，需要休眠仍须 ≥ RAM 的磁盘 swap。
}
