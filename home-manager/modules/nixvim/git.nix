# Git 插件：gitsigns + neogit + diffview
{
  ...
}: {
  programs.nixvim = {
    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "▁";
          };
          current_line_blame = true;
        };
      };

      neogit.enable = true;

      diffview.enable = true;
    };

    # Git 相关快捷键
    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
        options.desc = "Neogit";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<CR>";
        options.desc = "Blame";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action.__raw = ''
          function()
            -- 检测 diffview 是否已打开：查找 DiffviewFiles 类型的 buffer
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "DiffviewFiles" then
                vim.cmd("DiffviewClose")
                return
              end
            end
            vim.cmd("DiffviewOpen")
          end
        '';
        options.desc = "切换 Diff";
      }
    ];
  };
}
