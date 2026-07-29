# extraConfigLua — 终端智能设置、窗口管理、格式化开关等
{
  ...
}: {
  programs.nixvim.extraConfigLua = ''
    -- 终端分割线：bar 背景 #313244，文字亮色可见，WinSeparator 透明
    vim.api.nvim_set_hl(0, "TermSepBar", { bg = "#313244", fg = "#cdd6f4" })
    vim.api.nvim_set_hl(0, "TermSepLine", { fg = "#1e1e2e", bg = "#1e1e2e" })

    -- ============================================================
    -- 底部终端 (使用 toggleterm)
    -- ============================================================
    local Terminal = require("toggleterm.terminal").Terminal

    local function _term_on_open(term)
      vim.bo[term.bufnr].buflisted = true
      local win = term.window
      if win and vim.api.nvim_win_is_valid(win) then
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].cursorline = false
        vim.wo[win].winhighlight = "WinSeparator:TermSepLine"
        vim.wo[win].winbar = "%#TermSepBar#  终端 %="
      end
    end

    local _default_term = Terminal:new({
      direction = "horizontal",
      close_on_exit = true,
      on_open = _term_on_open,
    })

    vim.keymap.set("n", "<leader>tt", function() _default_term:toggle() end, { desc = "切换终端" })
    vim.keymap.set("t", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "关闭终端" })

    vim.keymap.set("n", "<leader>tn", function()
      local new_term = Terminal:new({
        direction = "horizontal",
        close_on_exit = true,
        on_open = _term_on_open,
      })
      new_term:open()
    end, { desc = "新终端" })

    -- 关闭当前分窗（仅关窗口，不退出编辑器）
    -- 排除 neo-tree / toggleterm 等插件窗口，只统计真正的编辑窗口。
    -- 原因：neo-tree 配置了 close_if_last_window，如果只计非浮动窗口总数，
    -- 会出现"编辑区 + neo-tree = 2 窗口 → :close 关掉编辑区 → neo-tree
    -- 检测到自己是最后窗口也自动关闭 → 0 窗口退出"的链式关闭问题。
    vim.keymap.set("n", "<leader>q", function()
      local real_wins = 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative == "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          -- 只统计普通编辑窗口，排除插件专用的 UI 窗口
          if ft ~= "neo-tree" and ft ~= "toggleterm" then
            real_wins = real_wins + 1
          end
        end
      end
      if real_wins <= 1 then
        vim.notify("已是最后一个窗口，使用 <leader>Q 退出编辑器", vim.log.levels.WARN, { title = "⚠ 提示" })
      else
        pcall(vim.cmd, "close")
      end
    end, { desc = "关闭分窗" })

    -- 退出确认：按两次 <leader>Q 才真正退出
    local _quit_confirm = false
    local _quit_timer = nil

    vim.keymap.set("n", "<leader>Q", function()
      if _quit_confirm then
        vim.cmd("qa!")
        return
      end
      _quit_confirm = true
      vim.notify("再按一次 <leader>Q 确认退出", vim.log.levels.WARN, { title = "⚠ 退出确认" })
      if _quit_timer then
        pcall(_quit_timer.close, _quit_timer)
      end
      _quit_timer = vim.defer_fn(function()
        _quit_confirm = false
      end, 3000)
    end, { desc = "退出编辑器" })

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

    -- diffview 文件面板快捷键：
    -- <leader>e 切换文件面板（默认被全局 <leader>e 遮蔽，这里显式设回 toggle_files）
    -- <leader>b 不绑定（文件树作用不大）
    -- 直接通过 setup() 设置，无需事后覆盖。
    local dv_ok, dv = pcall(require, "diffview")
    if dv_ok then
      dv.setup({
        keymaps = {
          file_panel = {
            ["<leader>e"] = "toggle_files",
          },
        },
      })
    end

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
    -- 分组会自动发现其下所有带 desc 的 keymap；显式 desc 项仅用于无前缀的顶层快捷键。
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        -- 文件 / 搜索
        { "<leader>f", group = "󰍉 查找 (Telescope)" },
        { "<leader>/", desc = "󰍉 当前文件内搜索" },
        { "<leader>w", desc = "󰆓 保存" },

        -- Git（子键 gg/gb/gd 由各自的 desc 自动发现）
        { "<leader>g", group = "󰊢 Git" },

        -- 代码：LSP 操作 + 格式化（子键 ca/cl/cf 自动发现）
        { "<leader>c", group = " 代码 (LSP/Format)" },

        -- 窗格
        { "<leader>s", group = "󰩬 窗格" },

        -- 诊断（子键 df 自动发现）
        { "<leader>d", group = " 诊断" },

        -- 终端（子键 tt/tn 自动发现）
        { "<leader>t", group = " 终端" },

        -- 窗口 / 退出
        { "<leader>x", desc = "󰅖 关闭缓冲区" },
        { "<leader>q", desc = "󰅖 关闭分窗" },
        { "<leader>Q", desc = "󰈆 退出编辑器" },
      })
    end
  '';
}
