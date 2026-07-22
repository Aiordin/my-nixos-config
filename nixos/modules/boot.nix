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

  boot.extraModprobeConfig = ''
    options rtw89_core disable_lps_deep=y
    options rtw89_pci disable_aspm=y
    options rtw89_8852be disable_ant_switch=y
  '';



}
