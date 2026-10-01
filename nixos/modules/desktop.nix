{  pkgs,config,lib,inputs,... }:
{

  imports = [ inputs.noctalia-greeter.nixosModules.default ];
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
#   services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
#   services.displayManager.sddm.enable = true;
#   services.desktopManager.plasma6.enable = true;


  # Install Niri
  programs.niri.enable = true;
  systemd.user.services.niri.enableDefaultPath = false;
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
  };

#   services.greetd = {
#       enable = true;
#       settings = {
#         default_session = {
#           # 💡 使用 tuigreet 并让它在登录成功后，用 niri-session 拉起你的桌面
#           # 参数含义：--time 显示时间，--asterisks 输入密码时显示星号，--remember 记住上次登录的用户名
# #           command = "''${pkgs.greetd}/bin/agreety --cmd niri";
#           command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --cmd ${config.programs.niri.package}/bin/niri-session";
#           user = "greeter";
#         };
#       };
#   };
  # Noctalia Shell 同步外观（壁纸/配色）到 greeter 时执行
  # `pkexec noctalia-greeter-apply-appearance`，对应 polkit action
  # `org.noctalia.greeter.apply-appearance`（包内默认 auth_admin → 每次弹授权框）。
  # 这里对 wheel 组免密授权，让 shell.greeter_sync.auto_sync 静默生效；
  # wheel 组本身即管理员（可 sudo），不构成额外提权。
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.noctalia.greeter.apply-appearance" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  programs.noctalia-greeter = {
    enable = true;
    # Optional: extra flags after `--` on noctalia-greeter-session
    greeter-args = "";
    # Full declarative greeter.toml (overwritten each activation). See examples/greeter.toml.
    # 光标必须与桌面会话保持一致：niri config.kdl / home.nix pointerCursor /
    # dconf / GSettings 全部是 Bibata-Modern-Ice 24。
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
    };
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

#   environment.pathsToLink = [
#     "/share/plasma/plasmoids"
#   ];

  # nautilus 文件管理器挂载支持（U盘 / 移动硬盘 / 网络共享）
  services.gvfs.enable = true;    # GVFS 用户态虚拟文件系统，提供挂载 UI
  services.udisks2.enable = true; # udisks2 磁盘挂载服务（gvfs 的挂载后端）
}
