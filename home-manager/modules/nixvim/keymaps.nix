# 全局快捷键（不归属特定插件的通用快捷键）
{
  ...
}: {
  programs.nixvim.keymaps = [
    # ---- 基本 ----
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "保存";
    }
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "清除高亮";
    }

    # ---- 窗格 ----
    {
      mode = "n";
      key = "<C-Left>";
      action = "<C-w>h";
      options.desc = "左窗格";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<C-w>j";
      options.desc = "下窗格";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<C-w>k";
      options.desc = "上窗格";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<C-w>l";
      options.desc = "右窗格";
    }
    {
      mode = "n";
      key = "<leader>sv";
      action = "<C-w>v";
      options.desc = "垂直分割";
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<C-w>s";
      options.desc = "水平分割";
    }

    # ---- 文件树（简单版，被 extraConfigLua 的智能切换覆盖） ----
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "文件树";
    }

    # ---- 缓冲区 ----
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<CR>";
      options.desc = "下一缓冲区";
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<CR>";
      options.desc = "上一缓冲区";
    }
  ];
}
