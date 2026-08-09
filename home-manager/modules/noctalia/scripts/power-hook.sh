#!/bin/bash
# Noctalia 电源管理 Hook —— 响应 power_profile_changed 事件
# 根据电源模式（performance/balanced/power-saver）调整系统行为。
# 环境变量：
#   NOCTALIA_POWER_PROFILE          当前模式（performance | balanced | power-saver）
#   NOCTALIA_POWER_PROFILE_PREVIOUS 之前的模式
#   NOCTALIA_POWER_PROFILE_ORIGIN   变更来源（noctalia | hardware_driver | …）

set -uo pipefail

PROFILE="${NOCTALIA_POWER_PROFILE:-}"
PREV="${NOCTALIA_POWER_PROFILE_PREVIOUS:-}"
ORIGIN="${NOCTALIA_POWER_PROFILE_ORIGIN:-}"

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/hook.log"

if [ -z "$PROFILE" ]; then
    echo "$(date) power_profile_changed: NOCTALIA_POWER_PROFILE not set, skipping" >> "$LOG_FILE"
    exit 0
fi

echo "$(date) power_profile_changed: origin=$ORIGIN prev=$PREV → $PROFILE" >> "$LOG_FILE"

case "$PROFILE" in
    power-saver)
        # 省电模式：暂停视频壁纸以降低 GPU/CPU 占用
        echo "$(date) power-saver: pausing mpvpaper video wallpapers" >> "$LOG_FILE"
        noctalia msg plugin noctalia/mpvpaper:service all pause >/dev/null 2>&1 || true
        ;;
    balanced|performance)
        # 平衡/性能模式：恢复视频壁纸
        echo "$(date) $PROFILE: resuming mpvpaper video wallpapers" >> "$LOG_FILE"
        noctalia msg plugin noctalia/mpvpaper:service all resume >/dev/null 2>&1 || true
        ;;
    *)
        echo "$(date) power_profile_changed: unknown profile '$PROFILE', ignoring" >> "$LOG_FILE"
        ;;
esac
