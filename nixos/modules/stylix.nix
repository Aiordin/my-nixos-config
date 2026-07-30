{ inputs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  # ============================================================
  # Stylix — Catppuccin Mocha 系统级统一主题
  # 字体由 nixos/modules/fonts.nix 统一管理
  # ============================================================
  stylix = {
    enable = true;
    autoEnable = true;

    targets = {
      gtk.enable = true;
      qt.enable = true;
    };

    # 壁纸由 linux-wallpaperengine 管理
    image = null;

    # Catppuccin Mocha 基础配色
    base16Scheme = {
      base00 = "1e1e2e"; base01 = "181825"; base02 = "313244";
      base03 = "45475a"; base04 = "585b70"; base05 = "cdd6f4";
      base06 = "f5e0dc"; base07 = "b4befe"; base08 = "f38ba8";
      base09 = "fab387"; base0A = "f9e2af"; base0B = "a6e3a1";
      base0C = "94e2d5"; base0D = "89b4fa"; base0E = "cba6f7";
      base0F = "f2cdcd";
    };

    polarity = "dark";
  };
}
