# 编辑器基础选项 + nixvim 顶层开关
{
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # 显式使用 flake 的 nixpkgs，消除 follows 警告
    nixpkgs.source = pkgs.path;

    opts = {
      number = true;
      relativenumber = true;
      laststatus = 3;
      mouse = "a";

      # 剪贴板
      clipboard = "unnamedplus";

      # 撤销
      undofile = true;
      undolevels = 10000;

      # 缩进
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
      smartindent = true;
      breakindent = true;

      # 换行
      wrap = false;
      linebreak = true;

      # 滚动偏移
      scrolloff = 8;
      sidescrolloff = 8;

      # 视觉
      cursorline = true;
      signcolumn = "yes";
      termguicolors = true;
      pumblend = 10; # 补全菜单半透明
      winblend = 0;

      # Markdown / 帮助文件中的字符隐藏
      conceallevel = 2;

      # 分窗
      splitright = true;
      splitbelow = true;

      # 搜索
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;

      # 计时
      timeoutlen = 300;
      updatetime = 200;

      # 补全
      completeopt = "menu,menuone,noselect";

      # 文件格式
      fileformat = "unix";
      fileencoding = "utf-8";

      # 交换文件（避免文件冲突时的数据丢失）
      swapfile = true;

      # 会话
      sessionoptions = "buffers,curdir,folds,help,tabpages,winsize";
    };

    globals.mapleader = " ";
  };
}
