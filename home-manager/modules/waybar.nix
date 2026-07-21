{ ... }:
{
    programs.waybar = {
    enable = true;
    # 如果你的系统需要特定的依赖或补丁，可以显式指定 package
    # package = pkgs.waybar;

    settings = {
        mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        # 模块布局
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [ "cpu" "memory" "clock" "tray" ];

        # --- Niri 工作区原生模块配置 ---
        "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
            # 可以根据状态定义不同的图标样式
            active = "";
            default = "";
            # 也可以直接指定在 Niri 配置文件中命名的工作区图标
            # "browser" = "";
            };
        };

        # --- Niri 窗口标题原生模块配置 ---
        "niri/window" = {
            format = "{}";
            icon = true;      # 是否显示当前聚焦应用的图标
            icon-size = 18;
        };

        # 其他基础模块配置示例
        "clock" = {
            format = "{:%Y-%m-%d %H:%M}";
        };
        };
    };

    # 状态栏 CSS 美化样式
    style = ''
        window#waybar {
            background-color: rgba(43, 48, 59, 0.5);
            border-bottom: 3px solid rgba(255, 255, 255, 0.1);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
        }

        /* Niri 工作区样式定义 */
        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
        }

        #workspaces button.focused,
        #workspaces button.active {
            color: #4ba6ef;
            background-color: rgba(255, 255, 255, 0.1);
        }

        /* Niri 窗口标题样式定义 */
        #window {
            font-weight: bold;
        }
    '';
    };

}
