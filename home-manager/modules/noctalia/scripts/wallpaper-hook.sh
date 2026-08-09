#!/bin/bash
# Noctalia 壁纸变更 Hook —— 视频壁纸缩略图取色桥接
# 当壁纸为视频文件时，提取首帧缩略图并设置为静态壁纸，
# 使 Noctalia 可以从缩略图提取主题色（直接对视频文件无法取色）。
#
# 环境变量（由 Noctalia 在触发 hook 前设置）：
#   NOCTALIA_WALLPAPER_PATH      当前壁纸绝对路径
#   NOCTALIA_WALLPAPER_CONNECTOR 关联的显示器名称

set -uo pipefail

WP="${NOCTALIA_WALLPAPER_PATH:-}"
CONNECTOR="${NOCTALIA_WALLPAPER_CONNECTOR:-}"

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/hook.log"

# 如果环境变量不可用，回退到 IPC（兼容旧版 Noctalia）
if [ -z "$WP" ]; then
    WP=$(noctalia msg wallpaper-get 2>/dev/null || true)
fi

echo "$(date) wallpaper_changed: WP=$WP connector=$CONNECTOR" >> "$LOG_FILE"

# 只处理视频文件（图片壁纸 Noctalia 可直接取色，无需缩略图）
if [[ -z "$WP" || ! -f "$WP" || ! "$WP" =~ \.(mp4|webm|mkv|mov|gif)$ ]]; then
    exit 0
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "$(date) wallpaper_changed: ERROR ffmpeg not found, cannot extract thumbnail from $WP" >> "$LOG_FILE"
    exit 1
fi

# 使用视频路径的 MD5 作为缩略图文件名，避免不同视频之间的碰撞
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/noctalia/wallpaper"
mkdir -p "$CACHE_DIR"

THUMB_NAME=$(echo -n "$WP" | md5sum | awk '{print $1}')
THUMB_PATH="$CACHE_DIR/${THUMB_NAME}.jpg"

# 提取缩略图（仅当缓存不存在时）
if [ ! -f "$THUMB_PATH" ]; then
    TMP_THUMB="${THUMB_PATH}.tmp.$$"
    if ffmpeg -y -i "$WP" -ss 00:00:01 -vframes 1 "$TMP_THUMB" 2>/dev/null; then
        mv "$TMP_THUMB" "$THUMB_PATH"
        echo "$(date) wallpaper_changed: thumbnail generated: $THUMB_PATH" >> "$LOG_FILE"
    else
        rm -f "$TMP_THUMB"
        echo "$(date) wallpaper_changed: ERROR ffmpeg failed to extract frame from $WP" >> "$LOG_FILE"
        exit 1
    fi
else
    echo "$(date) wallpaper_changed: using cached thumbnail: $THUMB_PATH" >> "$LOG_FILE"
fi

# 将缩略图设置为 Noctalia 壁纸以触发自动取色
if [ -f "$THUMB_PATH" ]; then
    if noctalia msg wallpaper-set "$THUMB_PATH" 2>/dev/null; then
        echo "$(date) wallpaper_changed: thumbnail set as wallpaper for color extraction" >> "$LOG_FILE"
    else
        echo "$(date) wallpaper_changed: ERROR wallpaper-set failed" >> "$LOG_FILE"
    fi
fi
