{ lib, pkgs, ... }:
let
  # Godot 在 Linux 上默认走 X11 后端（驱动注册顺序里 x11 在前），在 niri 这种
  # 纯 Wayland 会话里意味着多绕一层：Godot → Xwayland → xwayland-satellite → niri。
  # 本机实测（2560x1440 @ niri Scale 1.5，逻辑 1706x960）的两个后果：
  #   1. X11 模式下 DisplayServer 报 SCALE=1.0 / SCREEN_SIZE=2560x1440，
  #      编辑器 UI 按 1x 绘制，比周围的 Wayland 应用小 1.5 倍；
  #   2. 编辑器右键菜单闪烁（菜单本身是嵌入式绘制，问题出在 Xwayland 呈现链路）。
  # 强制原生 Wayland 后 SCALE 直接取到 1.5，菜单也正常。
  waylandArgs = "--display-driver wayland";

  # 跟着包的版本走，避免 nixpkgs 升级（4.7 → 4.8）后覆盖失效
  godotVersion = lib.versions.majorMinor pkgs.godot-mono.version;

  # 编辑器界面缩放下面的 activation 会固定到这个值：
  #   0=Auto（跟随桌面缩放，Wayland 下即 1.5）1=75% 2=100% 3=125%
  #   4=150% 5=175% 6=200% 7=Custom
  # 走 Wayland 时保持 0 即可；只有退回 X11 才需要手工给 4（那里的 Auto 只能得到 1.0）。
  editorDisplayScale = 0;
in
{
  # ============================================================
  # Godot 4 —— C#/.NET 版编辑器
  # ============================================================
  # godot-mono 与普通 godot 的唯一区别是编译时开启 module_mono_enabled，
  # 因此自带 C# 支持与 GodotSharp 程序集（同 godot_4-mono）。
  #
  # nixpkgs 的 wrapper 已经替我们做掉两件 C# 构建必需的事：
  #   1. 往 godot 可执行文件的 PATH 注入 dotnetCorePackages.sdk_8_0
  #      —— 编辑器里点 Build / Play 时调用的 `dotnet build` 因此能找到 dotnet；
  #   2. 设置 NUGET_FALLBACK_PACKAGES=$out/share/nuget/packages
  #      —— Godot.NET.Sdk、GodotSharp 等包从 store 离线解析，无需联网还原。
  #
  # 额外再装一份 dotnet-sdk_8，是为了在终端里直接 `dotnet build` / `dotnet run`
  # 调试 C# 项目（编辑器内构建走的是 wrapper 里那份）。两边同为 8.0，
  # 与 nixpkgs godot-mono 的构建/测试所用版本一致，避免 TFM 错配。
  home.packages = with pkgs; [
    godot-mono
    dotnet-sdk_8
  ];

  # .NET CLI 默认会联网上报遥测，并往 ~/.dotnet 写首次运行状态
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };

  # ============================================================
  # 桌面条目：让启动器启动的 Godot 也走 Wayland
  # ============================================================
  # 包自带的那份 Exec 只有二进制路径、不带参数，命令行手敲的参数对它无效。
  # 这里生成一个同名条目到 ~/.local/share/applications —— 该目录在
  # XDG_DATA_DIRS 中排在 profile 的 share/applications 之前，同名的会被它遮住。
  # 字段照抄包自带的那份，只改 Exec。
  #
  # 没用 HM 的 xdg.desktopEntries：该模块仍在给 pkgs.makeDesktopItem 传已被
  # 移除的 extraConfig 参数，而 makeDesktopItem 新签名改成了 settings，
  # 一旦使用就报 "The option `extraConfig' can no longer be used"。
  xdg.dataFile."applications/org.godotengine.Godot${godotVersion}-mono.desktop".text = ''
    [Desktop Entry]
    Name=Godot Engine ${godotVersion} (Mono)
    GenericName=Libre game engine
    Comment=Multi-platform 2D and 3D game engine with a feature-rich editor
    Keywords=game development;development;IDE;game engine;
    Exec=${pkgs.godot-mono}/bin/godot-mono ${waylandArgs} %f
    Icon=godot
    Terminal=false
    Type=Application
    MimeType=application/x-godot-project;
    Categories=Development;IDE;
    StartupWMClass=Godot
  '';

  # ============================================================
  # 编辑器界面缩放：固定为 Auto（0）
  # ============================================================
  # Wayland 下 Auto 会取 niri 的输出缩放（1.5），即跟随桌面，无需手工数值；
  # 只有退回 X11 才需要手工补偿（那里 Auto 只能得到 1.0，对应 150% = 索引 4）。
  # display_scale 枚举：0=Auto 1=75% 2=100% 3=125% 4=150% 5=175% 6=200% 7=Custom
  #
  # editor_settings-*.tres 是 Godot 自己频繁读写的运行时状态（字体、快捷键、
  # 最近项目……），所以不能用 home.file 做成只读 symlink —— 那样编辑器里
  # 保存任何设置都会失败。这里只对真实文件做幂等的一行替换，其余照旧归
  # Godot 自己管；本行在每次 home-manager switch 时被重新固定。
  #
  # 注意：Godot 退出时会写回内存中的设置，改完请重开编辑器。
  home.activation.godotEditorDisplayScale = ''
    for settings in "$HOME"/.config/godot/editor_settings-*.tres; do
      [ -f "$settings" ] || continue
      ${pkgs.gnused}/bin/sed -i -E 's|^(interface/editor/(appearance/)?display_scale) = .*|\1 = ${toString editorDisplayScale}|' "$settings"
    done
  '';
}
