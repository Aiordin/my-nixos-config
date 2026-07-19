{ ... }:
{
  #蓝牙
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
  #AMD and NVADI driver
  services.asusd.enable = true;
  services.supergfxd.enable = true;
  services.xserver.videoDrivers = [/*"modesetting"*/ "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    open = true;
#     prime = {
#       offload = {
#         enable = true;
#         enableOffloadCmd = true;
#       };
#       amdgpuBusId = "PCI:1:0:0";
#       nvidiaBusId = "PCI:6:0:0";
#     };
  };
  programs.gamemode.enable = true;
  security.polkit.enable = true;
#   services.auto-cpufreq.enable = false;
#   services.power-profiles-daemon.enable = true;

#   解决华硕工具的报错
#   systemd.tmpfiles.rules = [
#     "d /etc/asusd 0755 root root -"
#   ];

  programs.rog-control-center.autoStart = true;

  # Power & Sleep Behavior
  services.logind.settings.Login = {
    lidSwitchExternalPower = "ignore";
    lidSwitch = "ignore";
    suspendKey = "ignore";
    powerKey = "ignore";
  };

}
