# 文件树 + 模糊查找（fzf-native 增强排序）
{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    # ---- 文件树 ----
    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        window = {
          width = 32;
          mappings = {
            "o" = "open";
            "l" = "open";
            "h" = "close_node";
          };
        };
      };
    };

    # ---- 模糊查找 ----
    telescope = {
      enable = true;

      # fzf-native：用 Rust 写的 fzf 算法，大幅提升排序速度和结果质量
      extensions.fzf-native.enable = true;

      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fr" = "oldfiles";
        "<leader>fk" = "keymaps";
        "<leader>fd" = "diagnostics";
        "<leader>/" = "current_buffer_fuzzy_find";
      };
      settings.defaults = {
        layout_config.horizontal.prompt_position = "top";
        sorting_strategy = "ascending";
        # 文件搜索：忽略 .git/ 和常见的构建产物目录
        file_ignore_patterns = [
          "^.git/"
          "^node_modules/"
          "^target/"
          "^result/"
          "^.direnv/"
        ];
        mappings.i = {
          "<C-j>" = "move_selection_next";
          "<C-k>" = "move_selection_previous";
        };
      };
    };
  };
}
