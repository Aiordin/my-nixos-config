# 自动格式化 — conform.nvim
{
  ...
}: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 2000, lsp_fallback = true }
          end
        '';
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          rust = [ "rustfmt" ];
          javascript = [
            "prettierd"
            "prettier"
          ];
          typescript = [
            "prettierd"
            "prettier"
          ];
          javascriptreact = [
            "prettierd"
            "prettier"
          ];
          typescriptreact = [
            "prettierd"
            "prettier"
          ];
          json = [ "prettierd" ];
          html = [ "prettierd" ];
          css = [ "prettierd" ];
          scss = [ "prettierd" ];
          markdown = [ "prettierd" ];
          yaml = [ "prettierd" ];
          toml = [ "taplo" ];
          go = [
            "gofumpt"
            "goimports"
          ];
          bash = [ "shfmt" ];
          sh = [ "shfmt" ];
        };
      };
    };

    # 手动格式化快捷键
    keymaps = [
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.desc = "手动格式化";
      }
    ];
  };
}
