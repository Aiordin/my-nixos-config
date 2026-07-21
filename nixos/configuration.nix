                       # Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ /*config,*/ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/boot.nix
      ./modules/hardware.nix
      ./modules/network.nix
      ./modules/desktop.nix
      ./modules/fcitx5.nix
      ./modules/fonts.nix
      ./modules/programs.nix
      ./modules/firewall.nix
      ./modules/apps.nix
    ];


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations old";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];



  # Set your time zone.
  time.timeZone = "Asia/Shanghai";



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kid" = {
    isNormalUser = true;
    description = "kid";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "render" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
      qt6Packages.fcitx5-configtool
    ];
  };

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
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
