{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # 显式使用 flake 的 nixpkgs，消除 follows 警告
    nixpkgs.source = pkgs.path;

    # ============================================================
    # 主题
    # ============================================================
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          alpha = true;
          bufferline = true;
          gitsigns = true;
          lualine = true;
          neogit = true;
          noice = true;
          telescope = true;
          treesitter = true;
          which_key = true;
        };
      };
    };

    # ============================================================
    # 编辑器基础
    # ============================================================
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

    # ============================================================
    # 缩进线
    # ============================================================
    plugins.indent-blankline = {
      enable = true;
      settings = {
        scope.enabled = false;
        exclude.filetypes = [
          "alpha"
          "help"
          "lazy"
          "notify"
          "toggleterm"
          "TelescopePrompt"
        ];
      };
    };

    # ============================================================
    # 底部状态栏
    # ============================================================
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          theme = "catppuccin";
          globalstatus = true;
          component_separators = {
            left = "│";
            right = "│";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
      };
    };

    # ============================================================
    # 顶部标签栏
    # ============================================================
    plugins.bufferline = {
      enable = true;
      settings.options = {
        offsets = [ { filetype = "neo-tree"; } ];
        separator_style = "thin";
        close_command = "buffer %d | Bclose";
        right_mouse_command = "buffer %d | Bclose";
        always_show_bufferline = false;
      };
    };

    # ============================================================
    # 快捷键提示
    # ============================================================
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "modern";
        delay = 200;
      };
    };

    # ============================================================
    # 更好的命令行 / 消息
    # ============================================================
    plugins.noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        presets = {
          command_palette = true;
          long_message_to_split = true;
          lsp_doc_border = true;
        };
      };
    };

    # ============================================================
    # 启动页
    # ============================================================
    plugins.alpha = {
      enable = true;
      theme = "dashboard";
    };

    # ============================================================
    # 文件树
    # ============================================================
    plugins.neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        window = {
          width = 32;
          mappings = {
            "o" = "open";
            "l" = "open";
            "h" = "close_node";
          };
        };
      };
    };
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<CR>";
            node_incremental = "<CR>";
            node_decremental = "<BS>";
          };
        };
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        comment
        css
        dockerfile
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gomod
        gowork
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        python
        rust
        scss
        toml
        typescript
        vim
        vimdoc
        yaml
      ];
    };

    plugins.treesitter-textobjects.enable = true;

    # ============================================================
    # 模糊查找
    # ============================================================
    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fr" = "oldfiles";
        "<leader>fk" = "keymaps";
        "<leader>fd" = "diagnostics";
        "<leader>/" = "current_buffer_fuzzy_find";
      };
      settings.defaults = {
        layout_config.horizontal.prompt_position = "top";
        sorting_strategy = "ascending";
        mappings.i = {
          "<C-j>" = "move_selection_next";
          "<C-k>" = "move_selection_previous";
        };
      };
    };

    # ============================================================
    # Telescope 依赖 — 更好的图标
    # ============================================================
    plugins.web-devicons.enable = true;

    # ============================================================
    # LSP
    # ============================================================
    plugins.lsp = {
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

        # Python

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
    plugins.lspsaga = {
      enable = true;
      settings = {
        ui = {
          code_action = "";
          border = "rounded";
        };
      };
    };
    # 自动补全
    # ============================================================
    plugins.cmp = {
      enable = true;
      settings = {
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
      };
    };

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.luasnip.enable = true;
    plugins.friendly-snippets.enable = true;

    # ============================================================
    # Git
    # ============================================================
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "▁";
        };
        current_line_blame = true;
      };
    };

    plugins.neogit.enable = true;

    plugins.diffview.enable = true;

    # ============================================================
    # 自动格式化
    # ============================================================
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

    # ============================================================
    # 注释
    # ============================================================
    plugins.comment.enable = true;

    # ============================================================
    # 自动配对括号 / 引号
    # ============================================================
    plugins.nvim-autopairs.enable = true;

    # ============================================================
    # 彩虹括号
    # ============================================================
    plugins.rainbow-delimiters.enable = true;

    # ============================================================
    # 终端
    # ============================================================
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

    # ============================================================
    # Todo 注释高亮
    # ============================================================
    plugins.todo-comments = {
      enable = true;
      settings.keywords = {
        FIX.icon = " ";
        TODO.icon = " ";
        HACK.icon = " ";
        WARN.icon = " ";
        PERF.icon = " ";
        NOTE.icon = " ";
        TEST.icon = "⏽ ";
      };
    };

    # ============================================================
    # 全局快捷键
    # ============================================================
    keymaps = [
      # ---- 基本 ----
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "保存";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "退出";
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

      # ---- 文件树 ----
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "文件树";
      }

      # ---- 终端模式快捷键 ----
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.desc = "终端正常模式";
      }

      # ---- 终端模式窗格导航（Ctrl+方向键，不干扰终端字符输入） ----
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

      # ---- Git ----
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
        options.desc = "Neogit";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<CR>";
        options.desc = "Blame";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>DiffviewOpen<CR>";
        options.desc = "Diff";
      }

      # ---- 格式化 ----
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.desc = "手动格式化";
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

    extraConfigLua = ''
      -- 终端分割线：bar 背景 #313244，文字亮色可见，WinSeparator 透明
      vim.api.nvim_set_hl(0, "TermSepBar", { bg = "#313244", fg = "#cdd6f4" })
      vim.api.nvim_set_hl(0, "TermSepLine", { fg = "#1e1e2e", bg = "#1e1e2e" })

      -- ============================================================
      -- 底部终端 (编辑区对齐)
      -- ============================================================
      local _term_win = nil
      local _term_buf = nil

      local function _term_toggle()
        if _term_win and vim.api.nvim_win_is_valid(_term_win) then
          pcall(vim.api.nvim_win_close, _term_win, true)
          _term_win = nil
          return
        end
        -- 创建或复用终端缓冲区
        if not _term_buf or not vim.api.nvim_buf_is_valid(_term_buf) then
          _term_buf = vim.api.nvim_create_buf(false, false)
          vim.bo[_term_buf].buflisted = false
          vim.bo[_term_buf].filetype = "fterm"
          vim.api.nvim_buf_call(_term_buf, function()
            vim.fn.termopen(vim.o.shell)
          end)
          vim.api.nvim_create_autocmd("BufWipeout", {
            buffer = _term_buf,
            once = true,
            callback = function()
              _term_buf = nil
              _term_win = nil
            end,
          })
        end
        vim.cmd("below 15split")
        _term_win = vim.api.nvim_get_current_win()
        vim.wo[_term_win].number = false
        vim.wo[_term_win].relativenumber = false
        vim.wo[_term_win].signcolumn = "no"
        vim.wo[_term_win].cursorline = false
        -- 隐藏默认分割线，以 winbar 作为唯一分隔
        vim.wo[_term_win].winhighlight = "WinSeparator:TermSepLine"
        vim.api.nvim_win_set_buf(_term_win, _term_buf)
        vim.cmd("startinsert")
        -- winbar 在 startinsert 之后设置，避免被覆盖
        vim.wo[_term_win].winbar = "%#TermSepBar#  终端 %="
      end

      vim.keymap.set("n", "<leader>tt", _term_toggle, { desc = "终端" })
      vim.keymap.set("t", "<leader>tt", _term_toggle, { desc = "关闭终端" })

      -- 文件树智能切换：在文件树中按 <leader>e 关闭，否则聚焦文件树
      vim.keymap.set("n", "<leader>e", function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd("Neotree close")
        else
          vim.cmd("Neotree focus")
        end
      end, { desc = "文件树" })

      -- 智能关闭缓冲区：先跳到其他缓冲区再删，避免退出 Neovim
      -- 只在 listed 缓冲区（用户打开的文件）中找落点，排除 neo-tree 等 UI buffer
      vim.api.nvim_create_user_command("Bclose", function()
        local bufnr = vim.api.nvim_get_current_buf()
        -- 1) 先尝试 #（上一个缓冲区）
        local alt = vim.fn.bufnr("#")
        if alt ~= -1 and vim.api.nvim_buf_is_valid(alt) and alt ~= bufnr
          and vim.fn.buflisted(alt) == 1 then
          vim.api.nvim_set_current_buf(alt)
        else
          -- 2) 遍历 listed 缓冲区，找一个不是当前的
          local found = false
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if buf ~= bufnr and vim.fn.buflisted(buf) == 1 then
              vim.api.nvim_set_current_buf(buf)
              found = true
              break
            end
          end
          -- 3) 一个 listed 都找不到就新建空缓冲区
          if not found then
            vim.cmd("enew")
          end
        end
        -- 安全删除原缓冲区
        pcall(vim.cmd, "bdelete! " .. bufnr)
      end, {})

      vim.keymap.set("n", "<leader>x", "<cmd>Bclose<CR>", { desc = "关闭缓冲区" })

      -- Code Lens（Neovim 0.10+ 需用 vim.lsp.codelens.run，不能用 buf.code_lens_action）
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_code_lens", { clear = true }),
        callback = function(args)
          local buf = args.buf
          vim.keymap.set("n", "<leader>cl", function()
            vim.lsp.codelens.run({ bufnr = buf })
          end, { buffer = buf, desc = "Code Lens" })
        end,
      })

      -- 自动格式化的手动开关
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "禁用自动格式化", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "启用自动格式化" })

      -- 高亮 yank 区域
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          vim.highlight.on_yank({ timeout = 200 })
        end,
        group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
      })

      -- 保存时自动删除尾随空白（除 Markdown）
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype ~= "markdown" then
            local save_cursor = vim.fn.getpos(".")
            vim.cmd([[%s/\s\+$//e]])
            vim.fn.setpos(".", save_cursor)
          end
        end,
      })

      -- which-key 分组标题：按 <Space> 即可看到清晰的分类
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({
          { "<leader>f", group = "󰍉 查找文件 (Telescope)" },
          { "<leader>/", desc = "󰍉 当前文件内搜索" },
          { "<leader>g", group = "󰊢 Git" },
          { "<leader>b", group = "󰓩 缓冲区" },
          { "<leader>t", group = " 终端" },
          { "<leader>tt", desc = "切换终端" },
          { "<leader>c", group = " 代码 (LSP/Format)" },
          { "<leader>s", group = "󰩬 窗格" },
          { "<leader>d", group = " 诊断" },
        })
      end
    '';
  };
}
