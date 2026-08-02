# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./modules/nixvim
    ./modules/niri/niri.nix
    ./modules/starship.nix
    ./modules/waybar.nix
    ./modules/swayidle.nix
    ./modules/programs.nix
    ./modules/devbox.nix
    ./modules/eww.nix
    ./modules/ai/codewhale.nix
    ./modules/vscode.nix
  ];

  #锁屏设置
  #   xdg.configFile."kscreenlockerrc".text = ''
  #     [Daemon]
  #     Autolock=true
  #     LockOnResume=true
  #     LockGrace=5
  #   '';

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  # TODO: Set your username
  home = {
    username = "kid";
    homeDirectory = "/home/kid";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Aiordin";
        email = "69877954+Aiordin@users.noreply.github.com";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.05";
}
