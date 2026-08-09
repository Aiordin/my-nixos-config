{ pkgs, inputs, ... }:
{

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  programs.kitty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  # clash-verge-rev: Clash Meta GUI 客户端（社区维护 fork）
  # 原 programs.clash-verge 选项在 home-manager 中不存在，改为直接安装包
  services.mako = {
    enable = true; # notification daemon — Catppuccin Mocha 美化

    # Catppuccin Mocha 配色 — 与 Wynn-Dots 主题统一
    # 毛玻璃效果通过 layer-rule 在 niri 中设定
    settings = {
      default-timeout = 5000;
      icons = true;
      max-visible = 5;
      sort = "-time";
      font = "JetBrainsMono Nerd Font 12";
    };

    extraConfig = ''
      # ── Catppuccin Mocha 配色 ──
      background-color=#1e1e2eDD
      text-color=#cdd6f4
      border-color=#cba6f7
      border-radius=12
      progress-color=over #cba6f7
      width=360

      # 不同类型通知的颜色
      [urgency=low]
      border-color=#a6e3a1
      background-color=#1e1e2eBB

      [urgency=normal]
      border-color=#cba6f7

      [urgency=high]
      border-color=#f38ba8
      background-color=#1e1e2eFF

      # 分组通知样式
      [grouped]
      background-color=#313244DD
    '';
  };
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
    clash-verge-rev # Clash Meta GUI 客户端
    nixfmt
    xwayland-satellite
    linux-wallpaperengine # Steam 壁纸引擎（Wayland 层渲染）
    fastfetch
    nixd
    eww
    socat
    jaq
    tree
    wl-clipboard # Wayland 剪贴板（Neovim unnamedplus 依赖）
  ];
}
