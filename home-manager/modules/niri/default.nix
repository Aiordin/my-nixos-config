{ config, pkgs, ... }:
{
  # ============================================================
  # NyxNiri 模块化 niri 配置
  # 所有 .kdl 文件部署到 ~/.config/niri/
  # effects.kdl 由 toggle-eyecare.sh 在运行时管理，不清除
  # 快捷键通过 binds.kdl 管理
  # ============================================================
  xdg.configFile = {
    "niri/config.kdl" = {
      source = ./config.kdl;
      force = true;
    };
    "niri/monitor.kdl" = {
      source = ./monitor.kdl;
      force = true;
    };
    "niri/layout.kdl" = {
      source = ./layout.kdl;
      force = true;
    };
    "niri/binds.kdl" = {
      source = ./binds.kdl;
      force = true;
    };
    "niri/animations.kdl" = {
      source = ./animations.kdl;
      force = true;
    };
    "niri/rules.kdl" = {
      source = ./rules.kdl;
      force = true;
    };
    "niri/effects_normal.kdl" = {
      source = ./effects_normal.kdl;
      force = true;
    };
    "niri/effects_eyecare.kdl" = {
      source = ./effects_eyecare.kdl;
      force = true;
    };
    "niri/input__custom__.kdl" = {
      source = ./input__custom__.kdl;
      force = true;
    };
    # 用户自定义文件，首次部署模板后不覆盖
    "niri/__custom__.kdl" = {
      source = ./__custom__.kdl;
      force = false;
    };
    # 护眼模式切换脚本
    "niri/toggle-eyecare.sh" = {
      source = ./toggle-eyecare.sh;
      force = true;
    };
  };

  # 确保 effects.kdl 初始链接存在（toggle-eyecare.sh --sync 也会在 niri 启动时修复）
  home.activation.createEffectsLink = ''
    NIRI_DIR="$HOME/.config/niri"
    EFFECTS_LINK="$NIRI_DIR/effects.kdl"
    EFFECTS_NORMAL="$NIRI_DIR/effects_normal.kdl"

    if [ ! -L "$EFFECTS_LINK" ] && [ ! -f "$EFFECTS_LINK" ]; then
      ln -sf "$EFFECTS_NORMAL" "$EFFECTS_LINK"
    fi
  '';
}