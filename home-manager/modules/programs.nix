{ pkgs, inputs,  ... }:
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
    # gitFull includes git-credential-libsecret for gnome-keyring integration
    package = pkgs.gitFull;
    settings = {
      # Store credentials in gnome-keyring via libsecret Secret Service API
      credential.helper = "libsecret";
    };
  };



  home.packages = with pkgs; [
    nixfmt
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
