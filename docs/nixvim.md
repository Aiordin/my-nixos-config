# Nixvim 配置说明

## 什么是 Nixvim？

[Nixvim](https://github.com/nix-community/nixvim) 是一个用 **Nix 语言声明式配置 Neovim** 的工具。简单来说：你不需要手写一堆 Lua 配置文件（`init.lua`、各个插件的 `setup()` 调用等等），而是用 Nix 的语法描述你想要什么，nixvim 会帮你生成最终的 Neovim 配置。

本项目的 nixvim 配置位于 `home-manager/modules/nixvim/` 目录下，按功能拆分为多个模块文件：

```
home-manager/modules/nixvim/
├── default.nix       # 入口文件，引入所有子模块
├── theme.nix         # 主题/配色
├── options.nix       # 编辑器基础选项（行号、缩进、剪贴板等）
├── ui.nix            # 界面增强（状态栏、标签栏、缩进线、命令行等）
├── files.nix         # 文件树 + 模糊查找
├── treesitter.nix    # 语法高亮引擎
├── lsp.nix           # 语言服务器（代码补全、跳转、诊断）+ 诊断面板
├── fidget.nix        # LSP 进度通知（右下角状态提示）
├── completion.nix    # 自动补全菜单（含 cmdline 补全）
├── git.nix           # Git 集成（行内变更标记 + 分支对比 + 交互式面板）
├── formatting.nix    # 保存时自动格式化
├── editing.nix       # 编辑辅助（注释、括号配对、彩虹括号、surround、TODO 高亮）
├── terminal.nix      # 内置终端
├── keymaps.nix       # 全局快捷键
└── lua.nix           # 自定义 Lua 逻辑（兜底，放 nixvim 不支持的部分）
```

---

## 构建与生效

每次修改 nixvim 配置后，运行以下命令重新构建：

```bash
home-manager switch --flake .#kid@nixos
```

构建成功后重新打开 Neovim 即可看到效果。如果不想重启，也可以在 Neovim 中执行 `:Lazy reload` 重新加载插件。

> **不会影响现有 Neovim 吗？**
> 不会。nixvim 生成的配置文件是独立管理的，和 `~/.config/nvim/` 下的手写配置互不干扰。如果之前有手写配置，建议备份后删除，避免冲突。

---

## 主题 — Catppuccin Mocha

本配置使用 **Catppuccin Mocha** 暗色主题。这不是简单的"改个背景色"——主题已为所有 UI 插件开启了集成，确保各个插件的颜色风格统一：

- **alpha**（启动页）
- **bufferline**（顶部标签栏）
- **gitsigns**（行内 Git 标记）
- **lualine**（底部状态栏）
- **neogit**（Git 面板）
- **noice**（命令行美化）
- **telescope**（模糊查找）
- **treesitter**（语法高亮）
- **which-key**（快捷键提示）

主题配置位于 `theme.nix`，如果要换颜色风格，把 `flavour` 从 `"mocha"` 改为 `"latte"` / `"frappe"` / `"macchiato"` 即可。

---

## 编辑器基础设置

这些是 Neovim 编辑器本身的行为选项，配置在 `options.nix` 中。每个选项的含义：

| 选项 | 值 | 说明 |
|------|-----|------|
| 行号 | `number` + `relativenumber` | 当前行显示绝对行号，其他行显示相对于光标行的距离（方便 `5j` 这种快速跳转） |
| Tab 宽度 | `tabstop=2, shiftwidth=2` | 按 Tab 显示为 2 个空格的宽度，`>>` 缩进也是 2 格 |
| 缩进方式 | `expandtab=false` | **保留真正的 Tab 字符**而不是转换成空格（适合 Nix、Go 等语言） |
| 智能缩进 | `smartindent=true` | 换行时自动根据上一行缩进 |
| 鼠标 | `mouse=a` | 所有模式（普通、插入、可视、命令行）都支持鼠标点击和滚轮 |
| 剪贴板 | `unnamedplus` | 复制/粘贴直接使用系统剪贴板，无需额外操作 |
| 撤销文件 | `undofile=true` | 即使关闭文件再打开，也能撤销之前的修改（撤销记录保存在 `~/.local/state/nvim/undo/`） |
| 搜索区分大小写 | `smartcase` | 全小写搜索时不区分大小写，包含大写时区分大小写 |
| 增量搜索 | `incsearch=true` | 输入搜索词时实时跳转到匹配位置 |
| 搜索高亮 | `hlsearch=false` | 搜索完成后不保留高亮（按 `*` 或 `/` 后自动清除） |
| 高亮当前行 | `cursorline=true` | 光标所在行有背景高亮，方便定位 |
| 滚动边距 | `scrolloff=8` | 光标距离屏幕顶部/底部至少保持 8 行，不会贴边 |
| 不自动换行 | `wrap=false` | 长行不会折行显示，超出屏幕的部分水平滚动 |
| 补全菜单 | `completeopt=menu,menuone,noselect` | 始终显示补全菜单，但不自动选择第一项 |
| 分屏方向 | `splitright=true, splitbelow=true` | 垂直分屏时新窗口在右边，水平分屏时新窗口在下边 |
| 按键延迟 | `timeoutlen=300` | 按键序列等待时间 300ms（太短可能误判，太长操作迟钝） |
| 符号列 | `signcolumn=yes` | 始终显示左侧符号列（用于 Git 标记、诊断图标等） |
| 真彩色 | `termguicolors=true` | 启用 24 位真彩色（主题效果更好） |
| 补全菜单透明度 | `pumblend=10` | 补全菜单半透明，可以看到下面的代码 |
| 字符隐藏 | `conceallevel=2` | Markdown / 帮助文件中隐藏语法标记字符（如 `**粗体**` 只显示 **粗体**） |
| 断行缩进 | `breakindent=true` | 自动换行时保持缩进层级 |
| 文件格式 | `fileformat=unix` | 统一使用 Unix 换行符 (LF) |
| 文件编码 | `fileencoding=utf-8` | 默认使用 UTF-8 编码 |
| 交换文件 | `swapfile=true` | 启用交换文件，防止意外崩溃时的数据丢失 |
| 会话选项 | `sessionoptions=buffers,...` | 保存会话时包含缓冲区、目录、折叠、标签页等 |

**Leader 键**是空格（`<Space>`）。这意味着所有以 `<leader>` 开头的快捷键，都是先按一下空格，再按后面的键。比如"保存"就是：空格 + w。

---

## 快捷键速查表

> **阅读提示**：`<leader>` = 空格键；`<C-x>` = Ctrl + x；`<S-x>` = Shift + x；`<CR>` = 回车键。

### 文件操作

| 快捷键 | 功能 | 所属模块 |
|--------|------|----------|
| `<leader>w` | 保存文件 | keymaps |
| `<leader>e` | 切换文件树（打开/关闭/聚焦） | keymaps + lua |
| `<leader>ff` | 按文件名模糊查找 | files (Telescope) |
| `<leader>fg` | 全文内容搜索（ripgrep） | files (Telescope) |
| `<leader>fb` | 已打开的缓冲区列表 | files (Telescope) |
| `<leader>fh` | 帮助文档搜索 | files (Telescope) |
| `<leader>fr` | 最近打开的文件 | files (Telescope) |
| `<leader>fk` | 快捷键列表搜索 | files (Telescope) |
| `<leader>fd` | 诊断（错误/警告）列表 | files (Telescope) |
| `<leader>/` | 当前文件内模糊搜索 | files (Telescope) |
| `<leader>x` | 关闭当前缓冲区（标签页） | lua |
| `<leader>q` | 关闭当前分窗 | lua |
| `<leader>Q` | 退出编辑器（3秒内连按两次确认） | lua |

### 窗格（分屏）操作

| 快捷键 | 功能 |
|--------|------|
| `<C-Left>` | 聚焦到左边窗格 |
| `<C-Down>` | 聚焦到下面窗格 |
| `<C-Up>` | 聚焦到上面窗格 |
| `<C-Right>` | 聚焦到右边窗格 |
| `<leader>sv` | 垂直分屏（左右分） |
| `<leader>sh` | 水平分屏（上下分） |
| `<leader>s>` | 当前窗格加宽 5 列 |
| `<leader>s<` | 当前窗格缩窄 5 列 |
| `<leader>s+` | 当前窗格加高 3 行 |
| `<leader>s-` | 当前窗格降低 3 行 |

### 滚动

| 快捷键 | 功能 |
|--------|------|
| `<C-d>` | 向下半页（光标居中） |
| `<C-u>` | 向上半页（光标居中） |
| `n` | 下一搜索结果（居中） |
| `N` | 上一搜索结果（居中） |

### 系统剪贴板

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>y` | 普通/可视 | 复制到系统剪贴板 |
| `<leader>Y` | 普通/可视 | 复制整行到系统剪贴板 |

### Visual 模式增强

| 快捷键 | 功能 |
|--------|------|
| `<` / `>` | 减少/增加缩进（保持选中） |
| `J` / `K` | 将选中行向下/向上移动 |

### 诊断面板（Trouble）

| 快捷键 | 功能 |
|--------|------|
| `<leader>dd` | 切换工作区诊断面板 |
| `<leader>db` | 切换当前文件诊断面板 |
| `<leader>dl` | 切换 Location 列表面板 |
| `<leader>dq` | 切换 Quickfix 列表面板 |

### 缓冲区切换

| 快捷键 | 功能 |
|--------|------|
| `<S-l>` | 切换到下一个缓冲区 |
| `<S-h>` | 切换到上一个缓冲区 |

### 补全菜单操作

补全菜单会在你输入代码时自动弹出，你也可以手动触发：

| 快捷键 | 功能 |
|--------|------|
| `<C-Space>` | 手动触发补全 |
| `<C-j>` | 选择下一个补全项 |
| `<C-k>` | 选择上一个补全项 |
| `<C-b>` | 补全文档向上滚动 |
| `<C-f>` | 补全文档向下滚动 |
| `<CR>`（回车） | 确认当前选择的补全项 |
| `<Tab>` | 同上，确认当前选择的补全项 |
| `<C-e>` | 关闭补全菜单 |

### LSP（代码智能）操作

这些快捷键只在 LSP 服务器已「附着」的缓冲区中生效（即打开的文件类型有对应的语言服务器时）：

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gr` | 查找所有引用 |
| `gi` | 跳转到实现 |
| `gt` | 跳转到类型定义 |
| `K` | 悬浮窗口显示文档 |
| `<leader>rn` | 重命名符号 |
| `<leader>ca` | 代码操作（快速修复、导入补全等） |
| `<leader>cl` | Code Lens 操作（如 Rust 的"运行测试"） |
| `[d` | 跳转到上一个诊断 |
| `]d` | 跳转到下一个诊断 |
| `<leader>df` | 诊断详情浮窗 |

### Git 操作

| 快捷键 | 功能 | 来源 |
|--------|------|------|
| `<leader>gg` | 打开 Neogit 交互面板 | git.nix |
| `<leader>gb` | 查看当前行的 Git Blame | git.nix |
| `<leader>gd` | 打开/关闭 Diffview 差异对比 | git.nix |
| `]c` | 跳转到下一个变更块（hunk） | gitsigns 内置 |
| `[c` | 跳转到上一个变更块 | gitsigns 内置 |
| `<leader>hs` | 暂存（stage）当前变更块 | gitsigns 内置 |
| `<leader>hr` | 回退（reset）当前变更块 | gitsigns 内置 |
| `<leader>hR` | 回退整个文件的所有变更 | gitsigns 内置 |
| `<leader>hp` | 预览当前变更块的差异 | gitsigns 内置 |
| `<leader>hb` | 当前行 Blame（浮动窗口） | gitsigns 内置 |
| `<leader>hd` | 对光标所在单词执行 `git diff` | gitsigns 内置 |
| `<leader>hD` | 对光标所在行执行 `git diff` | gitsigns 内置 |
| `<leader>tb` | 切换当前行 Blame 显示/隐藏 | gitsigns 内置 |
| `ih` | 文本对象：选中当前变更块 | gitsigns 内置 |

### 终端操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<leader>tt` | 普通/终端 | 切换底部终端（打开/关闭） |
| `<leader>tn` | 普通 | 新建一个终端标签 |
| `<Esc>` | 终端 | 退出终端插入模式，进入终端普通模式 |
| `<C-Left>` | 终端 | 从终端跳到左窗格 |
| `<C-Down>` | 终端 | 从终端跳到下窗格 |
| `<C-Up>` | 终端 | 从终端跳到上窗格 |
| `<C-Right>` | 终端 | 从终端跳到右窗格 |

### 格式化

| 快捷键 / 命令 | 功能 |
|---------------|------|
| `<leader>cf` | 手动格式化当前文件 |
| `:FormatDisable` | 全局禁用保存时自动格式化 |
| `:FormatDisable!` | 仅当前缓冲区禁用自动格式化 |
| `:FormatEnable` | 重新启用自动格式化 |

### 其他

| 快捷键 | 功能 |
|--------|------|
| `<Esc>` | 清除搜索高亮 |
| `gcc` | 注释/取消注释当前行 |
| `gc` + 动作 | 注释选中区域（如 `gc3j` 注释下面3行） |

### which-key 分组总览

按空格键（leader）后等待 200ms，会弹出 which-key 菜单，显示所有可用的快捷键分组：

| 前缀 | 分组名 |
|------|--------|
| `<leader>f` | 󰍉 查找 (Telescope) |
| `<leader>g` | 󰊢 Git |
| `<leader>h` | Git hunk 操作 (gitsigns) |
| `<leader>c` |  代码 (LSP/Format) |
| `<leader>d` |  诊断（Trouble 面板 + 悬浮诊断） |
| `<leader>s` | 󰩬 窗格（分割 + 调整大小） |
| `<leader>y` | 复制到系统剪贴板 |
| `<leader>t` |  终端 |
| `<leader>x` | 󰅖 关闭缓冲区 |
| `<leader>q` | 󰅖 关闭分窗 |
| `<leader>Q` | 󰈆 退出编辑器 |

---

## 插件详解

下面按模块逐一说明每个插件的配置。

---

### 1. 文件树 — neo-tree（files.nix）

在编辑器左侧显示一个文件浏览器，就像 VS Code 的资源管理器。

**配置要点：**
- 窗口宽度：32 列
- **`close_if_last_window=true`**：当文件树是最后一个窗口时，关闭它就退出编辑器
- 文件树中按 `l` 或 `o` 打开文件/展开目录，按 `h` 收起目录

**智能切换逻辑**（在 lua.nix 中实现）：
`<leader>e` 的行为取决于你当前在哪个窗口：
- 如果当前在文件树中 → 关闭它
- 如果当前在编辑区 → 打开并聚焦文件树

这样你不会因为重复按 `<leader>e` 而在文件树和编辑区之间迷失方向。

---

### 2. 模糊查找 — Telescope（files.nix）

Telescope 是 Neovim 的"万能搜索框"。它的核心功能是通过模糊匹配快速找到你想要的任何东西——文件、文字、命令等等。

**依赖**：`ripgrep`（全文搜索）和 `fd`（文件名搜索），由 nixvim 的 `extraPackages` 自动安装，无需手动操作。

**在 Telescope 窗口中**：
- `<C-j>` / `<C-k>` 上下移动选择
- 输入关键词实时过滤结果
- 回车确认选择

**fzf-native 扩展**：启用了 `telescope-fzf-native`，这是一套用 Rust 重写的 fzf 模糊匹配算法。相比 Lua 原生实现，排序更智能（相似度感知），速度更快。首次构建时会编译该 C/Rust 组件，之后缓存。

**搜索忽略**：以下目录不会被搜索，避免噪音和性能问题：
- `.git/`、`node_modules/`、`target/`、`result/`、`.direnv/`

---

### 3. 语法高亮 — Treesitter（treesitter.nix）

Treesitter 是 Neovim 新一代的语法引擎。和传统的正则表达式高亮不同，Treesitter 会**真正解析代码的语法树**，因此高亮更准确，而且支持语法级别的"按结构选择"。

**已安装的语法解析器**（共 29 个）：

```
bash, c, comment, css, dockerfile, git_config, git_rebase,
gitattributes, gitcommit, gitignore, go, gomod, gowork,
html, javascript, json, lua, markdown, markdown_inline,
nix, python, rust, scss, toml, typescript, vim, vimdoc, yaml
```

**为什么要精确列举？**
nixvim 提供 `withAllGrammars` 选项可以一次性安装所有语法解析器，但那会安装 150+ 个，既浪费编译时间又占用存储空间。精确列举只安装实际需要的，构建更快。

**增量选择**：按 `<CR>`（回车）可以逐步扩大语法选择范围，`<BS>`（退格）缩小。例如：
- 第一次按 `<CR>`：选中当前单词
- 第二次按 `<CR>`：选中当前字符串
- 第三次按 `<CR>`：选中当前行
- ……以此类推，直到整个函数体

这个功能配合 `d`（删除）、`y`（复制）、`c`（修改）等操作符非常实用。

**文本对象**（通过 `treesitter-textobjects`）：
Treesitter 还提供了语法感知的文本对象，比如 `vif` 选中函数内部、`vaf` 选中包含函数签名的整个函数。这些是 treesitter-textobjects 提供的，无需手动配置快捷键。

---

### 4. LSP 语言服务器（lsp.nix）

LSP（Language Server Protocol，语言服务器协议）是代码智能的基石。每个编程语言都有一个对应的 LSP 服务器，它负责：

- **代码补全**：输入时提示可能的函数名、变量名
- **跳转**：从函数调用跳转到定义
- **诊断**：实时显示错误和警告
- **悬浮文档**：鼠标悬停（或按 `K`）查看函数说明
- **重命名**：安全地跨文件重命名符号

**本配置启用的 LSP 服务器**：

| 服务器 | 语言 | 说明 |
|--------|------|------|
| `nixd` + `nil_ls` | Nix | 两个互补：nixd 负责补全和跳转，nil_ls 负责诊断和格式化 |
| `lua_ls` | Lua | Neovim 的配置语言 |
| `ts_ls` | TypeScript/JavaScript/JSX/TSX | 前端开发必备 |
| `rust_analyzer` | Rust | Rust 官方推荐的 LSP，功能最全面 |
| `gopls` | Go | Go 官方 LSP |
| `marksman` | Markdown | 支持 wiki 链接、标题跳转 |
| `bashls` | Bash/Shell | Shell 脚本补全和诊断 |
| `html` | HTML | |
| `cssls` | CSS | |
| `jsonls` | JSON | |
| `pyright` | Python | Python 静态类型检查和补全 |
| `dockerls` | Docker | Dockerfile / docker-compose 补全和诊断 |
| `yamlls` | YAML | YAML 语法检查和 schema 验证 |

**特殊配置说明**：
- `nil_ls` 的格式化器被显式设置为 `nixfmt`，确保 Nix 文件格式化风格一致
- `rust_analyzer` 的 `installCargo` 和 `installRustc` 设为 `false`，因为我们通过系统/Nix 管理 Rust 工具链
- `ts_ls` 限定了文件类型，只在 JS/TS/JSX/TSX 文件中启用

**内联提示（Inlay Hints）**：默认开启。你会在代码中看到灰色的小字提示，比如变量类型、参数名等。如果觉得干扰，可以在 `lsp.nix` 中设置 `inlayHints = false`。

---

### 5. LSP 界面美化 — lspsaga（lsp.nix）

lspsaga 提供了更好看的 LSP 相关窗口（悬浮文档、代码操作菜单等），边框使用圆角样式（`border = "rounded"`）。它不影响 LSP 的功能，纯粹是视觉优化。

---

### 5.5 LSP 进度提示 — fidget.nvim（fidget.nix）

在编辑器右下角显示 LSP 的实时状态：

- **进度条**：当 LSP 正在分析代码、索引项目时，右下角会显示进度
- **诊断统计**：当前文件的错误/警告数量
- **LSP 服务器状态**：显示哪些 LSP 正在运行

配置为轻量模式：最多同时显示 16 个进度条，完成后 3 秒自动消失，日志级别设为 `warn`。

---

### 5.6 诊断列表面板 — trouble.nvim（lsp.nix）

Trouble 提供了一个集中的诊断浏览面板，比 `vim.diagnostic.setqflist()` 更方便：

| 快捷键 | 功能 |
|--------|------|
| `<leader>dd` | 切换**工作区**诊断面板（所有文件的错误/警告） |
| `<leader>db` | 切换**当前文件**诊断面板 |
| `<leader>dl` | 切换 Location 列表 |
| `<leader>dq` | 切换 Quickfix 列表 |

在 Trouble 面板中：
- `q` 关闭面板
- `<CR>` 跳转到对应位置
- 自动预览（`auto_preview=true`）：光标移动时在另一窗格预览
- 关闭后自动恢复窗口布局（`auto_close=true`）

---

### 6. 代码补全 — nvim-cmp（completion.nix）

`nvim-cmp` 是 Neovim 的补全引擎，它本身不提供补全项，而是从多个"来源"收集：

| 来源 | 说明 |
|------|------|
| `nvim_lsp` | 由 LSP 服务器提供的语义补全（最智能） |
| `luasnip` | 代码片段（snippets），输入缩写展开为代码模板 |
| `path` | 文件路径补全（输入 `./` 时自动提示文件） |
| `buffer` | 当前已打开文件中的单词（相当于全文补全） |

**代码片段**：通过 `luasnip` + `friendly-snippets` 实现。`friendly-snippets` 是一个社区维护的代码片段集合，覆盖了几十种语言。例如在 Rust 文件中输入 `fn` 然后按 `<Tab>`，可能会展开为一个完整的函数模板（取决于具体的片段定义）。

**性能优化**：大文件（>200KB）不启用补全（`performance.max_size=200`），避免补全卡顿。

**命令行补全**（`cmp-cmdline` + `cmp-cmdline-history`）：

除了代码补全，本配置还启用了命令行补全。当你在 `:` 命令模式或 `/` 搜索模式中输入时，也会弹出补全菜单，来源包括：
- 命令历史记录
- 文件路径

补全窗口使用圆角边框 + 半透明效果（`pumblend=10`），与整体 UI 风格统一。

---

### 7. 自动格式化 — conform.nvim（formatting.nix）

保存文件时自动调用对应格式化器，确保代码风格一致。

**默认行为**：每次保存文件（`:w` 或 `<leader>w`）时自动格式化，超时时间 2 秒。

**格式化器映射表**：

| 语言 | 格式化器 | 说明 |
|------|----------|------|
| Nix | `nixfmt` | Nix 官方格式化器 |
| Lua | `stylua` | Lua 社区标准格式化器 |
| Rust | `rustfmt` | Rust 官方格式化器 |
| Go | `gofumpt`（主）+ `goimports` | gofumpt 比 gofmt 更严格；goimports 自动管理 import |
| JavaScript/TypeScript | `prettierd` → `prettier` 回退 | prettierd 是基于 prettier 的守护进程版，速度更快 |
| JSX/TSX | 同上 | |
| HTML/CSS/SCSS | `prettierd` | |
| JSON | `prettierd` | |
| Markdown | `prettierd` | |
| YAML | `prettierd` | |
| TOML | `taplo` | TOML 专用格式化器 |
| Bash/Shell | `shfmt` | Shell 格式化工具 |

**为什么 JS/TS 有两个格式化器？**
`prettierd` 运行速度更快（守护进程模式），但不是所有环境都有。配置为 `["prettierd", "prettier"]` 表示优先使用 `prettierd`，如果不可用则回退到 `prettier`。

**临时禁用格式化**：
- `:FormatDisable` — 全局禁用（影响所有文件）
- `:FormatDisable!` — 仅当前文件禁用
- `:FormatEnable` — 恢复启用
- `<leader>cf` — 手动触发一次格式化

---

### 8. Git 集成（git.nix + lua.nix）

本配置集成了三层 Git 工具，覆盖从微观到宏观的完整工作流：

#### 8.1 gitsigns — 行内变更标记

gitsigns 在你的代码**左侧符号列**显示 Git 变更状态：
- 绿色竖线（`│`）：新增的行
- 黄色竖线（`│`）：修改的行
- 红色下划线（`▁`）：删除的行

同时，当前行末尾会以灰色文字显示 **Git Blame** 信息（谁、什么时候改的这行），由 `current_line_blame=true` 启用。

#### 8.2 diffview — 分支/提交差异审查

diffview 用于**审查较大范围的变更**。它打开一个专门的差异视图，左边是文件列表，右边是差异详情。

**常用命令**：

- `:DiffviewOpen` — 对比当前工作区与 HEAD（最近一次提交）
- `:DiffviewOpen main` — 对比当前分支与 main 分支
- `:DiffviewOpen HEAD~1` — 查看最近一次提交改了什么
- `:DiffviewClose` — 关闭差异视图
- `:DiffviewFileHistory %` — 查看当前文件的提交历史（`%` 代表当前文件路径）
- `:DiffviewToggleFiles` — 切换文件列表模式（显示所有文件 vs 只显示有变更的文件）

**Diffview 窗口内的操作**：

| 快捷键 | 功能 |
|--------|------|
| `q` | 关闭 Diffview |
| `<Tab>` | 在文件列表和差异面板之间切换焦点 |
| `<CR>` | 打开光标下文件的差异 |
| `o` | 在水平分屏中打开文件 |
| `]c` / `[c` | 在差异面板中跳转 hunk |
| `<leader>e` | 切换文件面板的显示/隐藏 |

#### 8.3 neogit — 交互式 Git 面板

Neogit 提供一个全屏的 Git 界面，灵感来自 Emacs 的 Magit。打开后可以用键盘完成所有 Git 操作。

打开：`<leader>gg`

**主界面分区**：
- **Staged（暂存区）**：即将提交的修改
- **Unstaged（未暂存区）**：已修改但未暂存的文件
- **Untracked（未跟踪）**：新建但未加入 Git 的文件

**常用操作**：

| 键 | 功能 |
|----|------|
| `s` | 暂存当前文件或 hunk |
| `S` | 暂存所有文件 |
| `u` | 取消暂存 |
| `c` | 打开提交窗口 |
| `p` | 推送（push） |
| `P` | 拉取（pull） |
| `l` | 查看日志（log） |
| `b` | 分支操作弹窗 |
| `M` | 合并分支 |
| `r` | Rebase 操作 |
| `z` | Stash（暂存工作区修改） |
| `Z` | Stash 面板 |
| `X` | Reset 操作 |
| `v` | 在差异面板中选择行 |
| `?` | 帮助面板 |
| `q` | 关闭 Neogit |

#### 典型工作流

**场景一：日常提交**
1. 写代码……
2. `<leader>gg` 打开 Neogit
3. 按 `s` 逐文件暂存（或展开后逐 hunk 暂存）
4. 按 `c` 提交，输入 commit message，`:wq` 保存
5. 按 `p` 推送

**场景二：提交前检查改了啥**
1. `<leader>gd` 打开 Diffview，过一遍所有变更
2. `]c` / `[c` 逐个 hunk 检查
3. 确认无误后 `<leader>gg` 进 Neogit 暂存提交

**场景三：误改了，快速回退**
- 某个 hunk 改错了 → `<leader>hr` 回退该 hunk
- 整个文件都想回退 → `<leader>hR`

**场景四：追踪"谁改的这行"**
1. `<leader>gb` 查看当前行 Blame → 找到 commit hash
2. `<leader>gd` 打开 Diffview
3. `:DiffviewOpen <hash>^..<hash>` 查看那个 commit 的具体变更

---

### 9. 内置终端 — toggleterm（terminal.nix + lua.nix）

终端面板在 Neovim 编辑区**正下方**打开（水平分割），高度为 15 行。

**配置特点**：
- 打开时自动进入插入模式（`start_in_insert=true`），可以直接输入命令
- 终端中按 `<Esc>` 退出插入模式，进入终端普通模式（可以滚动、复制输出等）
- 关闭终端时如果进程还在运行，会自动终止（`close_on_exit=true`）
- 高度可记忆（`persist_size=true`），手动调整高度后会保持

**终端窗口美化**（在 lua.nix 中实现）：
- 不显示行号、不显示符号列、不高亮当前行
- 顶部显示 winbar：` 终端`
- 窗格分隔线使用 Catppuccin 配色

---

### 10. UI 增强插件（ui.nix）

#### 10.1 lualine — 底部状态栏

- **全局状态栏**（`globalstatus=true`）：无论分了多少个窗口，始终只有一条状态栏在底部
- 显示内容：当前模式、文件名、Git 分支、LSP 诊断数量、文件类型、行列号、进度百分比
- 分隔符：竖线 `│`
- 颜色主题：自动跟随 Catppuccin

#### 10.2 bufferline — 顶部标签栏

- 像浏览器标签页一样显示打开的文件
- 分隔符样式：细线（`thin`）
- 不始终显示（`always_show_bufferline=false`）：只有打开多个文件时才出现
- 对 neo-tree 和 Diffview 的窗口做了偏移处理，不会把它们当成普通标签
- 关闭标签时调用自定义的 `Bclose` 命令，不会意外退出编辑器

#### 10.3 which-key — 快捷键提示

- 按 `<leader>`（空格）后等待 **200ms**，弹出分类好的快捷键菜单
- 使用 `modern` 预设样式
- 只要快捷键设置了 `desc`（描述），which-key 就能自动发现并分组
- 分组通过 lua.nix 中的 `wk.add()` 显式定义

#### 10.4 noice — 命令行 / 消息美化

- **命令面板**：输入 `:` 时显示更美观的命令提示
- **长消息自动分割**：很长的消息不会只显示一行，而是自动换行到浮动窗口
- **LSP 文档边框**：悬浮文档窗口有圆角边框
- **搜索计数**：`/` 搜索时显示 `[1/5]` 这样的匹配计数

#### 10.5 alpha — 启动页

打开 Neovim（不指定文件）时显示一个 dashboard，包含：
- ASCII 艺术字符画
- 快捷入口：新建文件、最近文件等

#### 10.6 indent-blankline — 缩进引导线

在代码的缩进位置显示竖线，帮助看清嵌套层次。

- **作用域高亮已禁用**（`scope.enabled=false`）：不会用不同颜色高亮当前作用域，保持简洁
- **排除的文件类型**：alpha（启动页）、help、lazy、notify、toggleterm、TelescopePrompt——这些界面缩进线没有意义

#### 10.7 web-devicons — 文件图标

为文件树、Telescope、bufferline 等提供文件类型图标（`.nix` 是雪花、`.rs` 是齿轮等等），纯视觉增强。

---

### 11. 编辑辅助插件（editing.nix）

#### 11.1 comment.nvim — 智能注释

- `gcc`：注释/取消注释当前行
- `gc` + 动作：注释选中的行（如 `gc3j` 注释下面 3 行）
- 自动识别当前文件类型的注释语法（Nix 用 `#`，Lua 用 `--`，JS 用 `//` 等）

#### 11.2 nvim-autopairs — 自动配对

输入 `(`、`[`、`{`、`"`、`'` 等字符时自动补全另一半，光标定位在中间。
输入右括号时光标会"跳过"而不产生重复括号。

#### 11.3 rainbow-delimiters — 彩虹括号

不同嵌套层级的括号用不同颜色显示，嵌套关系一目了然。

#### 11.4 mini.surround — surround 操作

快速在文本周围添加、删除、替换括号、引号等包围字符。与 `nvim-surround` 功能相同，但基于 `mini.nvim` 生态，更轻量。

| 操作 | 用法示例 | 效果 |
|------|----------|------|
| **添加** | `saiw"` | 给光标所在单词加双引号 → `"word"` |
| **添加** | `sa2f)` | 向前找 2 个字符并加括号 |
| **删除** | `sd"` | 删除最近的 `"` 包围 → `"hello"` → `hello` |
| **替换** | `sr"'` | 把双引号换成单引号 → `"hello"` → `'hello'` |
| **查找替换** | `sfc旧新` | 向前查找并替换包围 |

> 这些快捷键使用 `s` 前缀（不是 leader），which-key 会自动发现并显示。

#### 11.5 todo-comments — 特殊注释高亮

高亮特定关键词的注释，并配有图标，方便快速定位待办事项：

| 关键词 | 图标 | 用途 |
|--------|------|------|
| `TODO:` |  | 待完成的工作 |
| `FIX:` |  | 需要修复的问题 |
| `HACK:` |  | 临时解决方案 |
| `WARN:` |  | 需要注意的警告 |
| `PERF:` |  | 性能相关 |
| `NOTE:` |  | 备注说明 |
| `TEST:` | ⏽ | 测试相关 |

> 用法：在注释中写 `TODO: 这里还需要处理空值`，`TODO:` 会被高亮。

---

### 12. 自定义 Lua 逻辑（lua.nix）

当 nixvim 的声明式选项无法满足需求时，我们在 `extraConfigLua` 中用原始 Lua 代码实现。以下是不在其它模块中的自定义逻辑：

#### 12.1 智能关闭分窗（`<leader>q`）

普通 Neovim 的 `:close` 关闭当前窗口，但如果只剩最后一个编辑窗口，关了就会退出编辑器。

本配置的 `<leader>q` 会先统计真正的编辑窗口数量（排除文件树、终端等插件窗口）：
- 如果 ≥ 2 个编辑窗口 → 关闭当前窗口
- 如果只剩 1 个 → 弹出警告提示，拒绝关闭

这样你不会因为误按而意外退出。想要退出编辑器，请用 `<leader>Q`。

#### 12.2 退出确认（`<leader>Q`）

按一次 `<leader>Q` 会弹出提示："再按一次确认退出"。如果在 3 秒内再按一次，才会真正执行 `:qa!`（退出所有窗口）。3 秒后自动取消。

#### 12.3 智能关闭缓冲区（`<leader>x` 和 `:Bclose`）

普通的 `:bd`（删除缓冲区）有个问题：如果这是最后一个缓冲区，Neovim 会退出。

`Bclose` 自定义命令的处理逻辑：
1. 先跳到上一个用过的缓冲区（`#`）
2. 如果上一个不可用，遍历找另一个已加载的文件
3. 实在找不到就打开一个空白缓冲区
4. 最后安全删除原来的缓冲区

这样 `<leader>x` 永远不会意外退出编辑器。

#### 12.4 文件树智能切换

已在「文件树」部分说明。这里补充实现细节：`<leader>e` 在 lua.nix 中被重新绑定（覆盖 keymaps.nix 中的简单 toggle），根据当前窗口类型决定是关闭还是聚焦文件树。

#### 12.5 Yank 高亮

复制（yank）文本后，被复制的区域会短暂高亮 200ms，给你一个视觉反馈，确认复制成功。

#### 12.6 自动删除尾随空白

保存文件时自动删除每行末尾的空格和 Tab。**Markdown 文件除外**（因为 Markdown 中行尾两个空格表示强制换行）。

#### 12.7 Diffview 文件面板快捷键

在 Diffview 的文件面板中，按 `<leader>e` 可以切换文件列表的显示/隐藏。这个快捷键在 diffview 的 `setup()` 中显式设置，因为全局的 `<leader>e` 在 diffview 的文件面板中会被覆盖。

---

## 架构说明

本配置按功能拆分为 14 个模块，由 `default.nix` 统一引入。这种设计的好处：
- **可维护**：修改格式化配置不会影响 LSP 配置
- **可读**：每个文件职责单一，新人一眼能看懂
- **可复用**：如果将来要给另一台机器配 Neovim，可以直接复用子模块

配置的技术分层：

```
┌─────────────────────────────────────────┐
│  default.nix  （入口，imports 所有模块）    │
├─────────────────────────────────────────┤
│  nixvim 声明式选项（主体）                  │
│  plugins.<name>.enable + settings        │
│  keymaps = [...]                         │
│  opts = {...}                            │
├─────────────────────────────────────────┤
│  grammarPackages（Treesitter 精确列举）    │
├─────────────────────────────────────────┤
│  extraConfigLua（兜底：Lua 自定义逻辑）     │
│  终端美化、智能窗口管理、用户命令、自动命令    │
└─────────────────────────────────────────┘
```

### 添加新插件的模式

```nix
# 以添加一个新插件为例（在对应的 .nix 文件中）
programs.nixvim.plugins.<插件名> = {
  enable = true;
  settings = {
    # 这里的结构对应插件的 setup({ ... }) 参数
    option1 = "value";
    option2 = 42;
  };
};
```

### 添加新快捷键

```nix
# 方式一：添加全局快捷键
programs.nixvim.keymaps = [
  {
    mode = "n";                   # n=普通模式, v=可视模式, i=插入模式, t=终端模式
    key = "<leader>xx";           # 按键组合
    action = "<cmd>某个命令<CR>";  # 按下后执行的操作
    options.desc = "功能描述";     # 给 which-key 看的描述
  }
];

# 方式二：添加 LSP 快捷键
programs.nixvim.plugins.lsp.keymaps.lspBuf = {
  "<leader>xx" = "某个操作";
};
```

### 修改后如何生效

```bash
home-manager switch --flake .#kid@nixos
```

然后重新打开 Neovim 即可。无需手动运行 `:PackerSync` 或 `:Lazy sync` 之类的命令——nixvim 会自动处理插件的安装和更新。

---

## 常见问题

**Q: 为什么 Markdown 文件保存时不删除尾随空白？**
A: Markdown 中用两个空格 + 换行表示强制换行（hard line break）。为了不影响这个用法，自动删除尾随空白的逻辑跳过了 markdown 文件类型。详见 lua.nix。

**Q: Tab 键在补全菜单中确认，那怎么插入真正的 Tab？**
A: 本配置中 `expandtab=false`，在非补全状态下按 Tab 会插入真正的 Tab 字符。只有在补全菜单打开时，Tab 才充当确认键。如果需要在补全时插入 Tab，先按 `<C-e>` 关闭菜单再按 Tab。

**Q: 终端中 Ctrl+方向键为什么能切换窗格？不会和终端程序冲突吗？**
A: toggleterm 配置了 `insert_mappings=false`，意味着这些快捷键只在终端处于"终端普通模式"（按 `<Esc>` 后）时生效。在终端插入模式下，Ctrl+方向键会正常传递给终端程序（如 nvim 内部的终端里再跑另一个 nvim）。

**Q: 如何查看某个快捷键被谁占用了？**
A: 使用 `<leader>fk` 打开 Telescope 的快捷键列表，搜索即可。也可以用 `:Telescope keymaps` 命令。

**Q: 为什么用两个 Nix LSP（nixd + nil_ls）？**
A: 它们互补。nixd 在补全和跳转方面表现更好，nil_ls 在诊断（如检测未使用的变量）和格式化方面更可靠。
