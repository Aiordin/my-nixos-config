# Eww 桌面小组件模块 — 来自 Wynn-Dots 的 Catppuccin Macchiato 风格

{ pkgs, ... }:
{
  # eww 运行时依赖
  home.packages = with pkgs; [
    playerctl
    wireplumber
  ];

  # 将 eww 配置文件链接到 ~/.config/eww/
  xdg.configFile = {
    "eww/eww.yuck".source = ./eww/eww.yuck;
    "eww/eww.scss".source = ./eww/eww.scss;
    "eww/scripts/get_music.sh".source = ./eww/scripts/get_music.sh;
  };
}
