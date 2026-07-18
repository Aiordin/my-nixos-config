                       # Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ /*config,*/ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.configurationLimit = 5;

  boot.extraModprobeConfig = ''
    options rtw89_core disable_lps_deep=y
    options rtw89_pci disable_aspm=y
    options rtw89_8852be disable_ant_switch=y
  '';

#   打不上驱动时用
#   hardware.enableAllFirmware = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations old";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #蓝牙
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };


  #boot.kernelParams = ["acpi_backlight=video"];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";
    wifi.backend = "wpa_supplicant";
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-mozc
      fcitx5-gtk
      kdePackages.fcitx5-qt
      (fcitx5-rime.override {
        rimeDataPkgs = [
          rime-ice
        ];
      })
    ];
  };


  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  #v2ray
  services.v2raya.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
# 商店启用
  services.flatpak.enable = true;
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


#   appimage
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

#   no nano
  programs.nano.enable = false;
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };


  #Sleep mode
  services.logind.settings.Login = {
    lidSwitchExternalPower = "ignore";
    lidSwitch = "ignore";
    suspendKey = "ignore";
    powerKey = "ignore";
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kid" = {
    isNormalUser = true;
    description = "kid";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
      qt6Packages.fcitx5-configtool
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  # Install xwayland
  programs.xwayland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    git
    vim
    exfat
    nvtopPackages.full
    linux-wifi-hotspot
    crudini
#     tlpui
  ];

  environment.pathsToLink = [
    "/share/plasma/plasmoids"
  ];

  #输入法变量
#   environment.sessionVariables.XMODIFIERS = "@im={fcitx}";
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
