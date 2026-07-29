# 内置终端 — toggleterm
{
  ...
}: {
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        size = 15;
        hide_numbers = true;
        shade_filetypes = { };
        shade_terminals = true;
        shading_factor = 15;
        start_in_insert = true;
        insert_mappings = false;
        persist_size = true;
        direction = "horizontal";
        close_on_exit = true;
      };
    };

    # 终端模式快捷键
    keymaps = [
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.desc = "终端正常模式";
      }
      {
        mode = "t";
        key = "<C-Left>";
        action = "<C-\\><C-n><C-w>h";
        options.desc = "终端→左窗格";
      }
      {
        mode = "t";
        key = "<C-Down>";
        action = "<C-\\><C-n><C-w>j";
        options.desc = "终端→下窗格";
      }
      {
        mode = "t";
        key = "<C-Up>";
        action = "<C-\\><C-n><C-w>k";
        options.desc = "终端→上窗格";
      }
      {
        mode = "t";
        key = "<C-Right>";
        action = "<C-\\><C-n><C-w>l";
        options.desc = "终端→右窗格";
      }
    ];
  };
}
