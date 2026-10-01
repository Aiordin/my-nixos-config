# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    ./modules/neovim
    ./modules/fcitx5              # 输入法（fcitx5 + 候选窗主题/缩放）
    ./modules/noctalia             # 桌面 Shell（状态栏/锁屏/通知/启动器）
    ./modules/kitty               # Kitty 终端 + Noctalia 主题
    ./modules/niri                # NyxNiri niri 窗口管理器 + 快捷键 (binds.kdl)
    ./modules/fastfetch           # Fastfetch 系统信息面板
    ./modules/starship.nix
    ./modules/waybar.nix
    # ./modules/swayidle.nix      # 已停用：空闲管理由 Noctalia 接管（避免双锁屏）
    ./modules/programs.nix
    ./modules/godot.nix              # Godot 4 C#（.NET）编辑器 + dotnet SDK
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

    # 光标主题：Bibata-Modern-Ice（nixpkgs 的 bibata-cursors 包，自动链接到
    # ~/.icons 与 ~/.local/share/icons，并生成 default/index.theme）
    # 与 niri config.kdl、greeter.toml、dconf.settings 保持一致
    # pointerCursor 会自动设置 XCURSOR_THEME/XCURSOR_SIZE 环境变量
    pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # GTK 应用光标统一：写入 dconf 数据库（GTK 应用通过 GSettings 读取 cursor-theme）
  # 与 niri config.kdl、pointerCursor、greeter.toml 保持一致 —— Bibata-Modern-Ice 24
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 24;
    };
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
