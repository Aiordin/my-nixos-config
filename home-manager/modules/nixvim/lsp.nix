# LSP 语言服务器配置 + lspsaga 文档浮动窗
{
  pkgs,
  ...
}: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;

      servers = {
        # Nix
        nixd.enable = true;
        nil_ls = {
          enable = true;
          settings.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        };

        # Lua
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        # TypeScript / JavaScript
        ts_ls = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
        };

        # Rust
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };

        # Markdown
        marksman.enable = true;

        # Go
        gopls.enable = true;

        # Bash
        bashls.enable = true;

        # HTML / CSS / JSON
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
      };

      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gr" = "references";
          "gi" = "implementation";
          "gt" = "type_definition";
          "K" = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>df" = "open_float";
        };
      };

      # 内联提示
      inlayHints = true;
    };

    # 文档悬浮窗美化
    lspsaga = {
      enable = true;
      settings = {
        ui = {
          code_action = "";
          border = "rounded";
        };
      };
    };
  };
}
