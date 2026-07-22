{ pkgs,  ... }:
{

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  programs.kitty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  services.mako.enable = true; # notification daemon
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit

  programs.git = {
    enable = true;
    settings = {
      credential.helper = "cache --timeout=2592000";
    };
  };



  home.packages = with pkgs; [
#     inputs.codewhale.packages.${pkgs.system}.codewhale

    xwayland-satellite
    swaybg # wallpaper
    fastfetch
    steam
    steam-run
    nixd
    eww
    socat
    jaq
    tree
  ];
}
