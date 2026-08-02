# LazyVim — Nix + home-manager 集成
# 插件通过 Nix 管理，无需网络即可构建；自定义配置放在 ./lua/ 下
# 参考: https://github.com/LazyVim/LazyVim/discussions/1972
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # LazyVim 依赖的全部插件列表，通过 pkgs.vimPlugins 提供
  # 注意：LazyVim 更新后此列表可能需要同步调整
  plugins = with pkgs.vimPlugins; [
    LazyVim
    bufferline-nvim
    cmp-buffer
    cmp-nvim-lsp
    cmp-path
    cmp_luasnip
    conform-nvim
    dashboard-nvim
    dressing-nvim
    flash-nvim
    friendly-snippets
    gitsigns-nvim
    indent-blankline-nvim
    lualine-nvim
    neo-tree-nvim
    neoconf-nvim
    neodev-nvim
    noice-nvim
    nui-nvim
    nvim-cmp
    nvim-lint
    nvim-lspconfig
    nvim-notify
    nvim-spectre
    nvim-treesitter
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-ts-autotag
    nvim-ts-context-commentstring
    nvim-web-devicons
    persistence-nvim
    plenary-nvim
    telescope-fzf-native-nvim
    telescope-nvim
    todo-comments-nvim
    tokyonight-nvim
    trouble-nvim
    vim-illuminate
    vim-startuptime
    which-key-nvim
    # 以下插件在 nixpkgs 中的 attr 名与 LazyVim 期望的目录名不一致，需要手动映射
    { name = "LuaSnip"; path = luasnip; }
    { name = "catppuccin"; path = catppuccin-nvim; }
    { name = "mini.ai"; path = mini-nvim; }
    { name = "mini.bufremove"; path = mini-nvim; }
    { name = "mini.comment"; path = mini-nvim; }
    { name = "mini.indentscope"; path = mini-nvim; }
    { name = "mini.pairs"; path = mini-nvim; }
    { name = "mini.surround"; path = mini-nvim; }
  ];

  # 将 derivation 转为 lazy.nvim dev.path 期望的 { name, path } 条目
  # 对于已经是 { name, path } 的条目（如上方的 attr 名映射），原样保留
  mkEntryFromDrv = drv:
    if lib.isDerivation drv then
      { name = lib.getName drv; path = drv; }
    else
      drv;
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # LSP / 外部工具 —— 替代 mason.nvim（被禁用）
    extraPackages = with pkgs; [
      # LazyVim 自带格式化工具
      stylua
      # Telescope 依赖
      ripgrep
      fd
      # 常用 LSP（可按需增减）
      lua-language-server
      nixd
      # Git UI
      lazygit
      # Treesitter CLI（供 nvim-treesitter health check 使用）
      tree-sitter
      # C 编译器（供 nvim-treesitter 编译 parser，消除 health check 警告）
      gcc
    ];

    # lazy.nvim 引导插件
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    # lazy.nvim 配置：复用 Nix 管理的插件，禁用 mason
    initLua =
      let
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- 复用 Nix store 中的插件文件，无需下载
            path = "${lazyPath}",
            patterns = { "" },
            -- 未在 dev.path 中找到的插件回退到在线下载
            fallback = true,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- Nix 集成修正 ------------------------------------------------
            -- 强制启用 telescope-fzf-native（nix 中需要显式编译）
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- 禁用 mason，由 programs.neovim.extraPackages 统一管理
            -- LazyVim 已将 mason 仓库迁移至 mason-org 组织
            { "mason-org/mason-lspconfig.nvim", enabled = false },
            { "mason-org/mason.nvim", enabled = false },
            -- -----------------------------------------------------------
            -- 导入用户自定义插件配置
            { import = "plugins" },
            -- 清空 treesitter ensure_installed（由 Nix 管理 parser）
            -- 同时禁用 auto_install 和 build（避免运行时编译，完全由 Nix 提供）
            { "nvim-treesitter/nvim-treesitter",
              build = function() end,
              opts = { ensure_installed = {}, auto_install = false },
            },
          },
        })
      '';
  };

  # Treesitter parser 目录 —— 避免 query error: invalid node type
  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (
          pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins: with plugins; [
              c
              lua
              bash
              markdown
              markdown_inline
              nix
              python
              rust
              toml
              yaml
            ]
          )
        ).dependencies;
      };
    in
    "${parsers}/parser";

  # LazyVim 自定义配置目录
  # 参考 starter: https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
