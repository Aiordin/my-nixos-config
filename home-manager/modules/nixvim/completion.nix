# 自动补全：nvim-cmp + LuaSnip + cmdline 补全
{
  ...
}: {
  programs.nixvim.plugins = {
    cmp = {
      enable = true;
      settings = {
        # 补全窗口外观
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu";
          };
        };

        mapping = {
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.confirm({ select = true })";
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];

        snippet.expand = "luasnip";

        # 性能优化：大文件不显示补全
        performance = {
          max_size = 200; # KB
        };
      };
    };

    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp-buffer.enable = true;

    # cmdline 补全：在 / 搜索和 : 命令模式下提供补全
    cmp-cmdline = {
      enable = true;
    };

    # 补全源：cmdline 历史 + 路径
    cmp-cmdline-history.enable = true;

    luasnip.enable = true;
    friendly-snippets.enable = true;
  };
}
