# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

# config,
{ inputs, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/desktop.nix
    ./modules/fcitx5.nix # 仅 locale，输入法本身在 home-manager
    ./modules/fonts.nix
    ./modules/programs.nix
    ./modules/firewall.nix
    ./modules/ssh.nix # OpenSSH 服务端（端口 22，随 enable 自动放行）
    ./modules/clash-verge.nix # Clash Verge：服务模式 + TUN 能力
    ./modules/docker.nix
    ./modules/apps.nix
    ./modules/flatpak.nix
    ./modules/stylix.nix
    ./modules/KVM.nix
    ./modules/waydroid.nix

    # nix-flatpak module for declarative Flatpak override management
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # Data partition for games, media, etc.
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/0ff62194-ce58-4600-b976-61764f41ffe0";
    fsType = "btrfs";
    options = [ "noatime" "compress=zstd:3" "ssd" "discard=async" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations old";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users."kid" = {
    isNormalUser = true;
    description = "kid";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "docker"
    ];
    # 注意：输入法（fcitx5 + fcitx5-configtool）已迁移到 home-manager，
    # 见 home-manager/modules/fcitx5/
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    #     git
    vim
    exfat
    nvtopPackages.full
    linux-wifi-hotspot
    llama-cpp-vulkan
  ];

  # List services that you want to enable:
  # OpenSSH daemon 见 ./modules/ssh.nix

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
