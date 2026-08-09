# Kitty — NyxNiri Noctalia 终端配置
# 部署 kitty.conf + Noctalia 主题 + 用户自定义挂载点
{ ... }:
{
  programs.kitty = {
    enable = true;

    settings = {
      window_padding_width = 5;
      hide_window_decorations = "yes";
      background_opacity = "0.9";
      font_family = "JetBrains Mono";
      font_size = "12.0";
      remember_window_size = "no";
      confirm_os_window_close = 0;
      cursor_trail = 1;
      cursor_shape = "block";
      shell_integration = "no-cursor";
    };

    extraConfig = ''
      # Noctalia 主题
      include current-theme.conf

      # Windows-like shortcuts
      map ctrl+c copy_or_interrupt
      map ctrl+v paste_from_clipboard
      map ctrl+backspace send_text all \x17
      map ctrl+delete send_text all \x1bd
      map ctrl+a pipe @text clipboard sh -c "wl-copy 2>/dev/null || xclip -selection clipboard"
      map ctrl+equal change_font_size all +1.0
      map ctrl+minus change_font_size all -1.0
      map ctrl+0 change_font_size all 0

      mouse_map ctrl+scroll_up change_font_size all +1.0
      mouse_map ctrl+scroll_down change_font_size all -1.0

      # 用户自定义配置挂载点
      include __custom__.conf
    '';
  };

  # Noctalia 主题文件（符号链接到 ~/.config/kitty/current-theme.conf）
  xdg.configFile = {
    "kitty/current-theme.conf" = {
      source = ./themes/current-theme.conf;
      force = true;
    };
    "kitty/__custom__.conf" = {
      source = ./__custom__.conf;
      force = false;
    };
  };
}