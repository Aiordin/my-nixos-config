{ ... }:
{
  # nix-flatpak provides services.flatpak.overrides.settings for declarative
  # Flatpak permission management. This replaces the old environment.etc
  # approach which wrote to /etc/flatpak/overrides/ — a path Flatpak never
  # reads (it only reads /var/lib/flatpak/overrides/ for system overrides).
  services.flatpak.overrides.settings = {
    "com.tencent.WeChat".Context = {
      # Keys are always plural: filesystems, sockets.
      # nix-flatpak accepts Nix lists and converts to semicolon-separated format.
      filesystems = [
        "~/Downloads"
        "~/Documents"
        "~/Pictures"
        "~/Desktop"
      ];
      sockets = [
        "x11"
        "wayland"
      ];
    };
  };
}
