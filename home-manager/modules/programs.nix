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

  # ============================================================
  # 通知：由 Noctalia 内置通知守护提供，mako 配置整块停用
  # ============================================================
  # services.mako = {
  #   # Catppuccin Mocha 配色 — 与 Wynn-Dots 主题统一
  #   # 毛玻璃效果通过 layer-rule 在 niri 中设定
  #   enable = true; # notification daemon
  #
  #   settings = {
  #     default-timeout = 5000;
  #     icons = true;
  #     max-visible = 5;
  #     sort = "-time";
  #     font = "JetBrainsMono Nerd Font 12";
  #   };
  #
  #   extraConfig = ''
  #     # ── Catppuccin Mocha 配色 ──
  #     background-color=#1e1e2eDD
  #     text-color=#cdd6f4
  #     border-color=#cba6f7
  #     border-radius=12
  #     progress-color=over #cba6f7
  #     width=360
  #
  #     # 不同类型通知的颜色
  #     [urgency=low]
  #     border-color=#a6e3a1
  #     background-color=#1e1e2eBB
  #
  #     [urgency=normal]
  #     border-color=#cba6f7
  #
  #     [urgency=high]
  #     border-color=#f38ba8
  #     background-color=#1e1e2eFF
  #
  #     # 分组通知样式
  #     [grouped]
  #     background-color=#313244DD
  #   '';
  # };

  # ============================================================
  # 锁屏 / 空闲：由 Noctalia 内置空闲管理提供
  # （锁屏 300s / 关屏 360s / 挂起 900s，见 noctalia-config.toml 的 [idle]）
  # 两套空闲守护同时跑会互相抢屏（swaylock 与 Noctalia 锁屏）。
  # ============================================================
  # services.swayidle.enable = true; # idle management daemon

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
    (xwayland-satellite.overrideAttrs (old:
      let
        src = fetchzip {
          url = "https://github.com/Supreeeme/xwayland-satellite/archive/refs/tags/v0.8.1.tar.gz";
          hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
        };
      in
      {
        version = "0.8.1";
        inherit src;

        # buildRustPackage 的 cargoDeps 在定义期由 args.cargoHash 生成，
        # overrideAttrs 覆盖 cargoHash 不会重建它 —— 必须直接覆盖 cargoDeps。
        # 该 hash 对应 v0.8.1 的 Cargo.lock（与 nixpkgs 里 0.8.2 的 hash 不同）。
        cargoDeps = rustPlatform.fetchCargoVendor {
          pname = "xwayland-satellite";
          version = "0.8.1";
          inherit src;
          hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
        };
      }))
    # xwayland-satellite
    linux-wallpaperengine # Steam 壁纸引擎（Wayland 层渲染）
    fastfetch
    nixd
    eww
    socat
    jaq
    tree
    nautilus
    wl-clipboard # Wayland 剪贴板（Neovim unnamedplus 依赖）
    prismlauncher
    qbittorrent
  ];
}
