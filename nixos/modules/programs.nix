{ ... }:
{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.nano.enable = false;
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # 商店启用
  services.flatpak.enable = true;

  # appimage
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Install firefox.
  programs.firefox.enable = true;
  # Install xwayland
  programs.xwayland.enable = true;

  # Install Niri
  programs.niri.enable = true;
}
