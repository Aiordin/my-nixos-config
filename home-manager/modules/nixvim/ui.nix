# UI 插件：缩进线、状态栏、标签栏、快捷键提示、命令行美化、启动页、图标
{
  ...
}: {
  programs.nixvim.plugins = {
    # ---- 缩进线 ----
    indent-blankline = {
      enable = true;
      settings = {
        scope.enabled = false;
        exclude.filetypes = [
          "alpha"
          "help"
          "lazy"
          "notify"
          "toggleterm"
          "TelescopePrompt"
        ];
      };
    };

    # ---- 底部状态栏 ----
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";  # auto-detect catppuccin via integration
          globalstatus = true;
          component_separators = {
            left = "│";
            right = "│";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
      };
    };

    # ---- 顶部标签栏 ----
    bufferline = {
      enable = true;
      settings.options = {
        offsets = [
          { filetype = "neo-tree"; }
          { filetype = "DiffviewFiles"; }
        ];
        separator_style = "thin";
        close_command = "buffer %d | Bclose";
        right_mouse_command = "buffer %d | Bclose";
        always_show_bufferline = false;
      };
    };

    # ---- 快捷键提示 ----
    which-key = {
      enable = true;
      settings = {
        preset = "modern";
        delay = 200;
      };
    };

    # ---- 更好的命令行 / 消息 ----
    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        presets = {
          command_palette = true;
          long_message_to_split = true;
          lsp_doc_border = true;
        };
      };
    };

    # ---- 启动页 ----
    alpha = {
      enable = true;
      theme = "dashboard";
    };

    # ---- Telescope 图标依赖 ----
    web-devicons.enable = true;
  };
}
