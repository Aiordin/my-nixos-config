{ pkgs, ... }:
{
  # waybar 模块所需的运行时依赖
  home.packages = with pkgs; [
    brightnessctl
    pavucontrol
    blueman
    playerctl
    btop
    ncdu
  ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;
        # 防止窗口标题过长时挤压右侧模块
        fixed-center = true;

        # ============================================================
        # 模块布局
        # ============================================================
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "custom/powerprofile"
          "idle_inhibitor"
          "niri/language"
          "network"
          "bluetooth"
          "custom/vpn"
          "pulseaudio"
          "pulseaudio#input"
          "backlight"
          "mpris"
          "cpu"
          "memory"
          "temperature"
          "disk"
          "battery"
          "custom/notifications"
          "clock"
          "tray"
        ];

        # ============================================================
        # Niri 工作区
        # ============================================================
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
            focused = "●";
            urgent = "●";
          };
          disable-scroll = true;
        };

        # ============================================================
        # Niri 窗口标题
        # ============================================================
        "niri/window" = {
          format = "{title}";
          format-empty = "󰜌  桌面";
          icon = true;
          icon-size = 18;
          max-length = 80;
        };

        # ============================================================
        # Niri 键盘布局 — 左键切换输入法
        # ============================================================
        "niri/language" = {
          format = "{}";
          format-en = "EN";
          format-zh = "中";
          format-ja = "日";
          tooltip-format = "输入法: {variant}\n左键切换中/英";
          on-click = "fcitx5-remote -t";
          min-length = 2;
        };

        # ============================================================
        # 网络 — 左键 WiFi 菜单，右键开/关 WiFi
        # ============================================================
        network = {
          format-wifi = "{icon} {signalStrength}%";
          format-ethernet = "󰈀 有线";
          format-disconnected = "󰤮";
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" ];
          tooltip-format = ''
            {ifname}: {ipaddr}/{cidr}
            ▲ {bandwidthUpBits}  ▼ {bandwidthDownBits}
            左键 NetworkManager  右键开关 WiFi'';
          on-click = "kitty -e nmtui";
          on-click-right = "nmcli radio wifi $(nmcli radio wifi | grep -q enabled && echo off || echo on)";
        };

        # ============================================================
        # 蓝牙 — 左键开关，右键管理器
        # ============================================================
        bluetooth = {
          format-on = "󰂯";
          format-off = "󰂲";
          format-disabled = "";
          format-connected = "󰂱 {num_connections}";
          tooltip-format = "{status}  |  已连接 {num_connections} 设备\n{device_enumerate}";
          on-click = "bluetoothctl power toggle";
          on-click-right = "blueman-manager";
        };

        # ============================================================
        # VPN (v2raya) — 左键启动，右键停止
        # ============================================================
        "custom/vpn" = {
          exec = "systemctl --user is-active v2raya --quiet && echo '{\"text\":\"󰒃\",\"class\":\"active\"}' || echo '{\"text\":\"󰒄\",\"class\":\"inactive\"}'";
          interval = 10;
          on-click = "systemctl --user start v2raya";
          on-click-right = "systemctl --user stop v2raya";
          return-type = "json";
        };

        # ============================================================
        # 音频输出 (扬声器) — 左键静音，右键 pavucontrol，滚轮调音量
        # ============================================================
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 静音";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          tooltip-format = "{desc} — {volume}%\n左键静音  右键混音器  滚轮±5%";
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol";
          scroll-step = 5;
        };

        # ============================================================
        # 音频输入 (麦克风) — 左键静音
        # ============================================================
        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = " {source_volume}%";
          format-source-muted = " 静音";
          tooltip-format = ''
            {source_desc} — {source_volume}%
            左键切换静音'';
          on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          scroll-step = 0;
        };

        # ============================================================
        # 屏幕亮度 — 滚轮调亮度
        # ============================================================
        backlight = {
          device = "nvidia_0";
          format = "{icon}  {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
          tooltip-format = "屏幕亮度  {percent}%\n滚轮 ±5%";
        };

        # ============================================================
        # 媒体控制 — 左键播放/暂停，右键下一首，中键上一首
        # ============================================================
        mpris = {
          format = "{status_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          dynamic-len = 28;
          player-icons = {
            default = "▶";
            spotify = "";
            mpv = "";
          };
          status-icons = {
            playing = "";
            paused = "";
            stopped = "";
          };
          tooltip-format = "{player}\n{title} — {artist}";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-click-middle = "playerctl previous";
          ignored-players = [ ];
        };

        # ============================================================
        # CPU — 左键打开系统监控
        # ============================================================
        cpu = {
          format = "󰍛 {usage}%";
          tooltip-format = "使用率 {usage}%  频率 {load:.1f} GHz\n左键打开 btop";
          interval = 2;
          on-click = "kitty --class btop btop";
        };

        # ============================================================
        # 内存 — 左键打开系统监控
        # ============================================================
        memory = {
          format = "󰘚 {used:.1f}G";
          tooltip-format = "已用 {used:.1f}G / {total:.1f}G ({percentage}%)\n左键打开 btop";
          interval = 5;
          on-click = "kitty --class btop btop";
        };

        # ============================================================
        # CPU 温度 — 超过 90°C 变红
        # ============================================================
        temperature = {
          format = " {temperatureC}°C";
          tooltip-format = ''
            {temperatureC}°C
            临界温度 90°C
            传感器   acpitz'';
          thermal-zone = 0;
          critical-threshold = 90;
          interval = 5;
        };

        # ============================================================
        # 磁盘 — 左键打开空间分析
        # ============================================================
        disk = {
          format = "󰋊 {percentage_used}%";
          tooltip-format = "/  {used:.1f}G / {total:.1f}G\n左键打开 ncdu";
          path = "/";
          interval = 30;
          on-click = "kitty ncdu /";
        };

        # ============================================================
        # 电池 — 左键查看电源统计
        # ============================================================
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [
            "󰁺" "󰁻" "󰁼" "󰁽" "󰁾"
            "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"
          ];
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-full = "󰁹";
          format-time = "{H}:{M}";
          states = {
            warning = 20;
            critical = 10;
          };
          tooltip-format = ''
            电量 {capacity}%  剩余 {time}
            健康度 {health}%
            状态   {status}'';
          on-click = "kitty -e sh -c 'upower -i /org/freedesktop/UPower/devices/battery_BAT1; read -p \"按回车关闭...\"'";
        };

        # ============================================================
        # 通知中心 — 左键清除通知，右键切换勿扰
        # ============================================================
        "custom/notifications" = {
          exec = ''
            COUNT=$(makoctl list -j 2>/dev/null | jaq -r '[.data[] | flatten[]] | length' 2>/dev/null || echo 0)
            MODE=$(makoctl mode 2>/dev/null)
            if [ "$MODE" = "dnd" ]; then
              echo '{"text":"󰂛","class":"dnd","tooltip":"勿扰模式"}'
            elif [ "$COUNT" -gt 0 ]; then
              echo "{\"text\":\"󰂚 $COUNT\",\"class\":\"has\",\"tooltip\":\"$COUNT 条通知\"}"
            else
              echo '{"text":"󰂜","class":"none","tooltip":"无通知"}'
            fi
          '';
          interval = 5;
          return-type = "json";
          on-click = "makoctl dismiss -a";
          on-click-right = ''
            MODE=$(makoctl mode 2>/dev/null)
            if [ "$MODE" = "dnd" ]; then
              makoctl mode -s default
            else
              makoctl mode -s dnd
            fi
          '';
          escape = true;
        };

        # ============================================================
        # 时钟 — 左键切换显示，右键日历
        # ============================================================
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%m-%d %H:%M}";
          tooltip-format = ''
            <big><b>{:%Y-%m-%d}</b></big>
            <tt>{calendar}</tt>
            左键切换  右键打开日历'';
          on-click = "mode";
          on-click-right = "kitty -e sh -c 'cal -3; read -p \"按回车关闭...\"'";
        };

        # ============================================================
        # 电源模式 (asusctl)
        # ============================================================
        "custom/powerprofile" = {
          exec = ''asusctl profile -p 2>/dev/null | awk '/Active profile/{print $NF}' | sed 's/Quiet/{"text":"󰌪","class":"quiet","tooltip":"静音"}/; s/Balanced/{"text":"󰛲","class":"balanced","tooltip":"平衡"}/; s/Performance/{"text":"󰓅","class":"performance","tooltip":"性能"}/' '';
          interval = 5;
          on-click = "asusctl profile -n";
          return-type = "json";
        };

        # ============================================================
        # 防睡眠
        # ============================================================
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰛊";
          };
          tooltip-format-activated = "不休眠";
          tooltip-format-deactivated = "正常休眠";
        };

        # ============================================================
        # 系统托盘
        # ============================================================
        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    # ============================================================
    # CSS 主题
    # ============================================================
    style = ''
      /* ----------------------------------------------------------
        基础重置
         ---------------------------------------------------------- */
      window#waybar {
        background: rgba(17, 17, 27, 0.85);
        color: #cdd6f4;
        border-bottom: 1px solid rgba(69, 71, 90, 0.35);
        font-family: "JetBrains Mono Nerd Font", "Noto Sans CJK SC", sans-serif;
        font-size: 13px;
        font-weight: 500;
      }

      /* ----------------------------------------------------------
        通用 Pill 容器
         ---------------------------------------------------------- */
      #workspaces,
      #window,
      #language,
      #network,
      #bluetooth,
      #pulseaudio,
      #pulseaudio-input,
      #backlight,
      #mpris,
      #cpu,
      #memory,
      #temperature,
      #disk,
      #battery,
      #clock,
      #tray,
      #idle_inhibitor,
      #custom-powerprofile,
      #custom-vpn,
      #custom-notifications {
        background: rgba(49, 50, 68, 0.45);
        border-radius: 6px;
        margin: 4px 2px;
        padding: 0 10px;
        border: none;
        min-height: 0;
        transition: all 0.25s ease;
      }

      .modules-left > widget:first-child > #workspaces { margin-left: 6px; }
      .modules-right > widget:last-child > #tray { margin-right: 6px; }

      /* ----------------------------------------------------------
        统一 hover — 所有可交互模块
         ---------------------------------------------------------- */
      #language:hover,
      #network:hover,
      #bluetooth:hover,
      #pulseaudio:hover,
      #pulseaudio-input:hover,
      #backlight:hover,
      #mpris:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover,
      #disk:hover,
      #battery:hover,
      #clock:hover,
      #idle_inhibitor:hover,
      #custom-powerprofile:hover,
      #custom-vpn:hover,
      #custom-notifications:hover {
        background: rgba(88, 91, 112, 0.55);
      }

      /* ----------------------------------------------------------
        分组间距 — 在功能组之间留白
         ---------------------------------------------------------- */
      #custom-vpn         { margin-right: 6px; }
      #pulseaudio-input   { margin-left: 0; }

      /* ----------------------------------------------------------
        工作区
         ---------------------------------------------------------- */
      #workspaces { padding: 0 3px; }
      #workspaces button {
        padding: 0 7px;
        background: transparent;
        color: #6c7086;
        border-radius: 4px;
        transition: all 0.2s ease;
      }
      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.12);
        color: #cdd6f4;
      }
      #workspaces button.active,
      #workspaces button.focused {
        color: #89b4fa;
        background: rgba(137, 180, 250, 0.18);
      }
      #workspaces button.urgent {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.2);
      }

      /* ----------------------------------------------------------
        窗口标题
         ---------------------------------------------------------- */
      #window {
        font-weight: 600;
        color: #cdd6f4;
        background: rgba(49, 50, 68, 0.35);
      }

      /* ----------------------------------------------------------
        输入法
         ---------------------------------------------------------- */
      #language {
        color: #f5c2e7;
        font-weight: 700;
      }

      /* ----------------------------------------------------------
        电源模式 (asusctl)
         ---------------------------------------------------------- */
      #custom-powerprofile { font-size: 15px; padding: 0 8px; }
      #custom-powerprofile.quiet       { color: #a6e3a1; }
      #custom-powerprofile.balanced    { color: #89b4fa; }
      #custom-powerprofile.performance { color: #f38ba8; }

      /* ----------------------------------------------------------
        防睡眠
         ---------------------------------------------------------- */
      #idle_inhibitor { font-size: 15px; padding: 0 8px; color: #a6ada8; }
      #idle_inhibitor.activated { color: #f9e2af; }

      /* ----------------------------------------------------------
        网络
         ---------------------------------------------------------- */
      #network { color: #94e2d5; }
      #network.disconnected { color: #f38ba8; }

      /* ----------------------------------------------------------
        蓝牙
         ---------------------------------------------------------- */
      #bluetooth { color: #89b4fa; }
      #bluetooth.disabled,
      #bluetooth.off { color: #6c7086; }

      /* ----------------------------------------------------------
        VPN
         ---------------------------------------------------------- */
      #custom-vpn { font-size: 14px; }
      #custom-vpn.active   { color: #a6e3a1; }
      #custom-vpn.inactive { color: #6c7086; }

      /* ----------------------------------------------------------
        音频输出
         ---------------------------------------------------------- */
      #pulseaudio { color: #89b4fa; }
      #pulseaudio.muted { color: #f38ba8; }

      /* ----------------------------------------------------------
        麦克风
         ---------------------------------------------------------- */
      #pulseaudio-input { color: #cba6f7; }
      #pulseaudio-input.muted { color: #f38ba8; }

      /* ----------------------------------------------------------
        屏幕亮度
         ---------------------------------------------------------- */
      #backlight { color: #f9e2af; }

      /* ----------------------------------------------------------
        媒体控制
         ---------------------------------------------------------- */
      #mpris { color: #a6e3a1; font-size: 12px; }
      #mpris.paused { color: #6c7086; }

      /* ----------------------------------------------------------
        CPU / 内存 / 温度 / 磁盘
         ---------------------------------------------------------- */
      #cpu         { color: #fab387; }
      #memory      { color: #a6e3a1; }
      #temperature { color: #f2cdcd; }
      #temperature.critical { color: #f38ba8; }
      #disk        { color: #b4befe; }

      /* ----------------------------------------------------------
        电池
         ---------------------------------------------------------- */
      #battery { color: #94e2d5; }
      #battery.charging { color: #a6e3a1; }
      #battery.plugged  { color: #89b4fa; }
      #battery.warning  { color: #fab387; }
      #battery.critical { color: #f38ba8; }

      /* ----------------------------------------------------------
        通知中心
         ---------------------------------------------------------- */
      #custom-notifications { font-size: 14px; color: #89b4fa; }
      #custom-notifications.dnd  { color: #f38ba8; }
      #custom-notifications.has  { color: #f9e2af; }
      #custom-notifications.none { color: #6c7086; }

      /* ----------------------------------------------------------
        时钟
         ---------------------------------------------------------- */
      #clock {
        color: #f5c2e7;
        font-weight: 700;
      }

      /* ----------------------------------------------------------
        系统托盘
         ---------------------------------------------------------- */
      #tray > .passive { -gtk-icon-effect: dim; }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: #f9e2af;
      }

      /* ----------------------------------------------------------
        Tooltip
         ---------------------------------------------------------- */
      tooltip {
        background: rgba(24, 24, 37, 0.96);
        border: 1px solid rgba(137, 180, 250, 0.35);
        border-radius: 8px;
        padding: 8px 12px;
        color: #cdd6f4;
        font-size: 12px;
      }
      tooltip label { padding: 1px 0; }
    '';
  };
}
