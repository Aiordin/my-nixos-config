# ============================================================
# Fcitx5 输入法 — 完全由 Home Manager 管理（用户级）
# ============================================================
# 系统级只剩 locale（nixos/modules/fcitx5.nix），输入法的包、systemd
# 用户服务、会话环境变量、候选窗主题都在这里声明。
#
# 候选窗「缩放不统一」的成因：GTK 侧用 ~/.config/gtk-3.0/settings.ini 的
# gtk-xft-dpi 单独放大了字号（120 DPI），而 fcitx5 候选窗按默认 10pt/96DPI
# 渲染，视觉上明显偏小。这里通过 classicui 的 Font + DPI/分数缩放开关把
# 候选窗拉到同一视觉尺度。
# ============================================================
{ pkgs, ... }:
let
  # Noctalia 动态皮肤名，与 noctalia-config.toml 的 theme.templates.user.* 对应
  themeName = "nyxmellow";
in
{
  # ============================================================
  # Fcitx5 本体（Wayland 前端）
  # ============================================================
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # niri 是 Wayland 合成器，使用 wayland 前端以获得正确的候选窗定位
      # （此时不设 GTK_IM_MODULE/QT_IM_MODULE，走应用的 text-input 协议）
      waylandFrontend = true;

      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons # 拼音 / 双拼 / 五笔等中文输入
        fcitx5-mozc # 日文
        fcitx5-gtk # GTK 应用 IM 模块
        kdePackages.fcitx5-qt # Qt 应用 IM 模块
        (fcitx5-rime.override {
          rimeDataPkgs = [ rime-ice ]; # 雾凇拼音
        })
      ];
    };
  };

  # 图形化配置工具：已包含在 qt6Packages.fcitx5-with-addons 里
  # （重复安装 pkgs.qt6Packages.fcitx5-configtool 会因为 bin/fcitx5-config-qt
  #  同名造成 buildEnv 冲突）。原系统级配置里的 fcitx5-configtool 已随之移除。

  # ============================================================
  # 经典界面（候选窗）设置
  # ============================================================
  # 只声明 classicui 单文件，不接管整个 ~/.config/fcitx5/ 目录：
  # profile / config / 其它 addon 配置仍然可写，用户在 fcitx5-configtool
  # 里的输入法方案改动不会丢失。
  #
  # 代价：界面（主题/字体）这几项不再能在 GUI 里持久修改，要改改这里。
  home.file.".config/fcitx5/conf/classicui.conf".text = ''
    # 由 home-manager 声明（home-manager/modules/fcitx5/default.nix）
    # 主题名需要和 Noctalia 渲染输出的主题目录一致
    Theme=${themeName}
    UseDarkTheme=False
    UseAccentColor=True

    # 候选窗字体：与 GTK 侧 120 DPI 放大后的视觉字号对齐
    Font="Noto Sans CJK SC 12"
    MenuFont="Noto Sans CJK SC 12"
    TrayFont="Noto Sans CJK SC 10"

    # 面板随屏幕 DPI / 分数缩放一起放大
    PerScreenDPI=True
    EnableFractionalScale=True

    PreferTextIcon=False
    ShowLayoutNameInIcon=True
    UseInputMethodLanguageToDisplayText=True
    WheelForPaging=True
    FullWidthHighlight=True
  '';

  # ============================================================
  # Qt SVG 插件路径 —— 让候选窗真正加载 panel.svg / highlight.svg
  # ============================================================
  # classicui 用 QImageReader 读主题里的 SVG，而 Qt6 的 SVG 支持是插件
  # （imageformats/libqsvg.so，来自 qtsvg）。fcitx5 自带的 wrapper 只把
  # 自己的 plugins 目录 prepend 进 QT_PLUGIN_PATH，而那个目录下只有
  # plasma/ 和 platforminputcontexts/，没有 imageformats —— 于是 SVG 背景
  # 加载失败，回退到 theme.conf 里的 [*/Background] Color。
  #
  # 这正是「夜间候选窗文字看不见」的成因：回退色原本硬编码为 #ffffff，
  # 而 classicui 的 NormalColor 取自 on_surface，暗色模式下也是 #ffffff，
  # 白底白字。浅色模式下 on_surface 是深色，所以只有夜间会暴露。
  #
  # 这里把 qtsvg 的插件目录交给 systemd 服务，wrapper 会把 fcitx5 自己的
  # plugins 目录 prepend 上去，两者共存。
  systemd.user.services.fcitx5-daemon.Service.Environment = [
    "QT_PLUGIN_PATH=${pkgs.qt6.qtsvg}/lib/qt-6/plugins"
  ];

  # ============================================================
  # 屏蔽 fcitx5 包自带的 XDG autostart
  # ============================================================
  # fcitx5 包在 etc/xdg/autostart/ 带了一个 org.fcitx.Fcitx5.desktop，
  # systemd-xdg-autostart-generator 据此生成
  # app-org.fcitx.Fcitx5@autostart.service，在图形会话里抢先拉起一个实例。
  # 那个实例不属于本模块的 fcitx5-daemon.service：
  #   * 没有下面注入的 QT_PLUGIN_PATH（qtsvg），SVG 背景加载失败；
  #   * 它占住 D-Bus 名字后，fcitx5-daemon.service 启动会立刻退出
  #     （日志：Could not load addon dbus），主题从此不再随渲染更新。
  # 用户级 ~/.config/autostart 的同名文件按 XDG 规范遮蔽后者。
  xdg.configFile."autostart/org.fcitx.Fcitx5.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Fcitx 5
    Comment=由 home-manager 的 fcitx5-daemon.service 接管，此处显式禁用
    Exec=true
    Hidden=true
    X-GNOME-Autostart-enabled=false
  '';

  # ============================================================
  # Noctalia 动态皮肤模板
  # ============================================================
  # 模板放在 templates/ 下（只读链接），Noctalia 读取后按壁纸取色渲染，
  # 把结果写到同级目录的 theme.conf / panel.svg / highlight.svg —— 输出
  # 路径可写，不会被 home-manager 覆盖。
  #
  # 路径必须与 noctalia-config.toml 里的
  #   theme.templates.user.nyxmellow_*.input_path 保持一致
  xdg.dataFile = {
    "fcitx5/themes/${themeName}/templates/theme.conf" = {
      source = ./nyxmellow/theme.conf;
      force = true;
    };
    "fcitx5/themes/${themeName}/templates/panel.svg" = {
      source = ./nyxmellow/panel.svg;
      force = true;
    };
    "fcitx5/themes/${themeName}/templates/highlight.svg" = {
      source = ./nyxmellow/highlight.svg;
      force = true;
    };
  };
}
