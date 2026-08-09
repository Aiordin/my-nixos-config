# Noctalia — 桌面 Shell 配置
# 管理 noctalia-config.toml、壁纸/主题同步脚本
# Noctalia 内置替代了 waybar(状态栏)、swaylock(锁屏)、swayidle(空闲)、mako(通知)
{ pkgs, ... }:
{
  # ============================================================
  # Noctalia 运行时依赖
  # ============================================================
  home.packages = with pkgs; [
    # Noctalia 桌面 Shell 本体（状态栏、锁屏、通知、启动器、空闲管理）
    noctalia
    # 壁纸同步依赖
    inotify-tools
    jq
    # mpvpaper 视频壁纸
    mpvpaper
    # 视频缩略图提取
    ffmpeg
    # md5sum 用于视频哈希
    coreutils
    # 护眼模式依赖
    wlsunset
  ];

  # ============================================================
  # Noctalia 配置文件
  # ============================================================
  xdg.configFile = {
    "noctalia/noctalia-config.toml" = {
      source = ./noctalia-config.toml;
      force = true;
    };

    # 主题模式切换脚本（明/暗模式同步 GTK/GSettings）
    "noctalia/theme-sync.sh" = {
      source = ./scripts/theme-sync.sh;
      force = true;
    };

    # 壁纸变更 Hook（视频缩略图取色 + Stylix 同步）
    "noctalia/wallpaper-hook.sh" = {
      source = ./scripts/wallpaper-hook.sh;
      force = true;
    };

    # 锁屏/解锁 Hook（暂停/恢复 mpvpaper 视频壁纸）
    "noctalia/session-hook.sh" = {
      source = ./scripts/session-hook.sh;
      force = true;
      executable = true;
    };

    # 电源管理 Hook（性能/平衡/省电模式切换联动）
    "noctalia/power-hook.sh" = {
      source = ./scripts/power-hook.sh;
      force = true;
      executable = true;
    };

    # mpvpaper 壁纸同步脚本（视频 → Noctalia 原生壁纸取色）
    "noctalia/mpvpaper-sync.sh" = {
      source = ./scripts/mpvpaper-sync.sh;
      force = true;
      executable = true;
    };

    # mpv Lua Hook（视频文件加载时同步取色）
    "noctalia/mpv-hook.lua" = {
      source = ./scripts/mpv-hook.lua;
      force = true;
    };
  };
}
