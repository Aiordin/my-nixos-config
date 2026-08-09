#!/bin/bash
# Noctalia 会话 Hook —— 锁屏/解锁时暂停/恢复视频壁纸（mpvpaper）
# 锁屏后视频壁纸继续播放会白白消耗 GPU/解码资源，且解锁前会暴露壁纸内容；
# 通过 mpvpaper 插件的 IPC 命令冻结/解冻播放，行为与 Noctalia 锁屏钩子联动。
#
# 用法:
#   session-hook.sh lock    # session_locked 事件
#   session-hook.sh unlock  # session_unlocked 事件

set -uo pipefail

ACTION="${1:-}"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/hook.log"

case "$ACTION" in
  lock)
    echo "$(date) session_locked: pausing mpvpaper video wallpapers" >> "$LOG_FILE"
    noctalia msg plugin noctalia/mpvpaper:service all pause >/dev/null 2>&1 || true
    ;;
  unlock)
    echo "$(date) session_unlocked: resuming mpvpaper video wallpapers" >> "$LOG_FILE"
    noctalia msg plugin noctalia/mpvpaper:service all resume >/dev/null 2>&1 || true
    ;;
  *)
    echo "usage: $0 lock|unlock" >&2
    exit 1
    ;;
esac
