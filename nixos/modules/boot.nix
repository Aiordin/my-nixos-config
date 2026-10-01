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



}
