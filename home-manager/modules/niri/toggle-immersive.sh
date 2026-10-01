#!/bin/sh
set -eu

NIRI_DIR="$HOME/.config/niri"
IMMERSIVE_LINK="$NIRI_DIR/immersive.kdl"
NORMAL_CONFIG="$NIRI_DIR/immersive_normal.kdl"
IMMERSIVE_CONFIG="$NIRI_DIR/immersive_on.kdl"

current_target=$(readlink "$IMMERSIVE_LINK" 2>/dev/null || true)
if [ "$current_target" = "$IMMERSIVE_CONFIG" ]; then
    target="$NORMAL_CONFIG"
else
    target="$IMMERSIVE_CONFIG"
fi

if [ "$current_target" != "$target" ]; then
    ln -sfn "$target" "$IMMERSIVE_LINK"
    if command -v niri >/dev/null 2>&1; then
        niri msg action reload-config 2>/dev/null || true
    fi
fi