# LSP 语言服务器配置 + lspsaga 文档浮动窗 + trouble.nvim 诊断面板
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

        # Python
        pyright.enable = true;

        # Docker
        dockerls.enable = true;

        # YAML
        yamlls.enable = true;
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

    # 诊断列表面板 — 替代 vim.diagnostic.setqflist()
    # <leader>dd — 切换工作区诊断列表
    # <leader>db — 切换缓冲区诊断列表
    # <leader>dl — 切换 Location 列表
    # <leader>dq — 切换 Quickfix 列表
    trouble = {
      enable = true;
      settings = {
        auto_close = true;
        auto_preview = true;
        focus = false;
        modes = {
          diagnostics = {
            auto_open = false;
          };
        };
      };
    };
  };

  # Trouble 快捷键
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>dd";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "诊断面板 (workspace)";
    }
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options.desc = "诊断面板 (buffer)";
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options.desc = "Location 列表";
    }
    {
      mode = "n";
      key = "<leader>dq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options.desc = "Quickfix 列表";
    }
  ];
}
