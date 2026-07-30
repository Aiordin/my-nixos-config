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

    # ---- 系统剪贴板 ----
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = ''"+y'';
      options.desc = "复制到系统剪贴板";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>Y";
      action = ''"+Y'';
      options.desc = "复制行到系统剪贴板";
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

    # ---- 快速调整窗格大小 ----
    {
      mode = "n";
      key = "<leader>s>";
      action = "<cmd>vertical resize +5<CR>";
      options.desc = "窗格加宽";
    }
    {
      mode = "n";
      key = "<leader>s<";
      action = "<cmd>vertical resize -5<CR>";
      options.desc = "窗格缩窄";
    }
    {
      mode = "n";
      key = "<leader>s+";
      action = "<cmd>resize +3<CR>";
      options.desc = "窗格加高";
    }
    {
      mode = "n";
      key = "<leader>s-";
      action = "<cmd>resize -3<CR>";
      options.desc = "窗格降低";
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

    # ---- 滚动（保持光标居中） ----
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "向下半页";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "向上半页";
    }
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "下一搜索结果";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "上一搜索结果";
    }

    # ---- 缩进保持选择（visual mode） ----
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "减少缩进";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "增加缩进";
    }

    # ---- 移动行 ----
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "下移行";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "上移行";
    }
  ];
}
