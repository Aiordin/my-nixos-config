{  pkgs,config, ... }:
{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
#   services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
#   services.displayManager.sddm.enable = true;
#   services.desktopManager.plasma6.enable = true;


  # Install Niri
  programs.niri.enable = true;
  systemd.user.services.niri.enableDefaultPath = false;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # 💡 使用 tuigreet 并让它在登录成功后，用 niri-session 拉起你的桌面
          # 参数含义：--time 显示时间，--asterisks 输入密码时显示星号，--remember 记住上次登录的用户名
#           command = "''${pkgs.greetd}/bin/agreety --cmd niri";
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.programs.niri.package}/bin/niri-session";
          user = "greeter";
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
}
