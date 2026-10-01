#!/bin/bash

# Get current theme mode (from env, or fallback to CLI)
THEME_MODE="${NOCTALIA_THEME_MODE}"
if [ -z "$THEME_MODE" ]; then
    THEME_MODE=$(noctalia msg theme-mode-get 2>/dev/null || echo "dark")
fi

echo "Syncing theme mode to: $THEME_MODE"

# Function to update settings in INI files safely
update_ini() {
    local file="$1"
    local key="$2"
    local val="$3"
    
    if [ ! -f "$file" ]; then
        mkdir -p "$(dirname "$file")"
        echo "[Settings]" > "$file"
    fi
    
    # Escape special characters in key and val for sed
    local esc_key esc_val
    esc_key=$(printf '%s\n' "$key" | sed 's/[[\.*^$()]/\\&/g')
    esc_val=$(printf '%s\n' "$val" | sed 's/[|\&]/\\&/g')

    if grep -q "^${esc_key}=" "$file"; then
        sed -i "s|^${esc_key}=.*|${key}=${esc_val}|" "$file"
    else
        # Append right after the [Settings] section line
        if grep -q "^\[Settings\]" "$file"; then
            sed -i "/^\[Settings\]/a ${key}=${esc_val}" "$file"
        else
            echo "${key}=${val}" >> "$file"
        fi
    fi
}

set_gsettings() {
    local scheme="$1"
    local val="$2"
    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.gnome.desktop.interface "$scheme" "$val" 2>/dev/null || true
    fi
}

scheme_val="prefer-dark"
gtk_theme="adw-gtk3-dark"
dark_pref="true"

if [ "$THEME_MODE" = "light" ]; then
    scheme_val="prefer-light"
    gtk_theme="adw-gtk3"
    dark_pref="false"
fi

# 1. Update GSettings (affects Firefox, Chromium, VS Code, and libadwaita apps)
set_gsettings color-scheme "$scheme_val"
set_gsettings gtk-theme "$gtk_theme"

# 2. Update GTK 3.0 settings.ini
update_ini "$HOME/.config/gtk-3.0/settings.ini" "gtk-application-prefer-dark-theme" "$dark_pref"
update_ini "$HOME/.config/gtk-3.0/settings.ini" "gtk-theme-name" "$gtk_theme"

# 3. Update GTK 4.0 settings.ini
update_ini "$HOME/.config/gtk-4.0/settings.ini" "gtk-application-prefer-dark-theme" "$dark_pref"

# 4. 光标样式统一
#    GTK 侧曾经单独写成 36px，而 niri config.kdl / home.nix pointerCursor /
#    dconf 都是 Bibata-Modern-Ice 24 —— 窗口内光标和合成器光标会大小不一。
#    这里从 XCURSOR_THEME / XCURSOR_SIZE（home-manager 的 pointerCursor 导出）
#    回写 GTK3/GTK4，保证单一事实来源。
cursor_theme="${XCURSOR_THEME:-Bibata-Modern-Ice}"
cursor_size="${XCURSOR_SIZE:-24}"

for gtk_version in 3.0 4.0; do
    update_ini "$HOME/.config/gtk-$gtk_version/settings.ini" "gtk-cursor-theme-name" "$cursor_theme"
    update_ini "$HOME/.config/gtk-$gtk_version/settings.ini" "gtk-cursor-theme-size" "$cursor_size"
done

# 5. GSettings 侧同步（Firefox / Chromium / Qt-GTK 平台主题都读这一份）
set_gsettings cursor-theme "$cursor_theme"
set_gsettings cursor-size "$((cursor_size))"
