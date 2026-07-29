# 文件树 + 模糊查找
{
  ...
}: {
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
        mappings.i = {
          "<C-j>" = "move_selection_next";
          "<C-k>" = "move_selection_previous";
        };
      };
    };
  };
}
