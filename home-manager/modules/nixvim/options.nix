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
      clipboard = "unnamedplus";
      undofile = true;
      undolevels = 10000;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
      smartindent = true;
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      cursorline = true;
      signcolumn = "yes";
      termguicolors = true;
      splitright = true;
      splitbelow = true;
      timeoutlen = 300;
      updatetime = 200;
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;
      completeopt = "menu,menuone,noselect";
    };

    globals.mapleader = " ";
  };
}
