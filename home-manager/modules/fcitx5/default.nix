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
