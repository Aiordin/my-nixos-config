# Nixvim 配置说明

本配置使用 [nixvim](https://github.com/nix-community/nixvim) 模块，通过 Nix 语法声明式管理 Neovim 的插件、主题、快捷键和 LSP 设置，避免手写 Lua 配置。配置文件位于 `home-manager/modules/nixvim.nix`。

## 构建与生效

```bash
home-manager switch --flake .#kid@nixos
```

构建成功后重新打开 Neovim 即可生效。

## 主题

- **Catppuccin Mocha** — 暗色主题，已为所有 UI 插件启用集成（alpha、bufferline、gitsigns、lualine、neogit、noice、telescope、treesitter、which-key）

## 编辑器基础设置

| 选项 | 值 | 说明 |
|------|-----|------|
| 行号 | `number` + `relativenumber` | 绝对行号 + 相对行号 |
| Tab | `tabstop=2, shiftwidth=2` | 2 空格缩进 |
| 缩进 | `expandtab=false` | 保留 Tab 字符（适合 Nix/Go） |
| 鼠标 | `mouse=a` | 全模式启用 |
| 剪贴板 | `unnamedplus` | 与系统剪贴板同步 |
| 搜索 | `smartcase` + `incsearch` | 智能大小写 + 增量搜索 |
| 光标行 | `cursorline=true` | 高亮当前行 |
| 滚动边距 | `scrolloff=8, sidescrolloff=8` | 距边缘 8 行/列时开始滚动 |
| 补全菜单 | `menu,menuone,noselect` | 始终显示菜单，不自动选择 |

Leader 键为空格（`<Space>`）。

---

## 插件列表与快捷键

### 文件树 — neo-tree

- `<leader>e` — 切换文件树侧边栏
- 在文件树中：`l` / `o` 打开，`h` 收起目录

### 模糊查找 — Telescope

- `<leader>ff` — 查找文件
- `<leader>fg` — 全文搜索（ripgrep）
- `<leader>fb` — 缓冲区列表
- `<leader>fh` — 帮助标签
- `<leader>fr` — 最近文件
- `<leader>fk` — 快捷键列表
- `<leader>fd` — 诊断列表
- `<leader>/` — 当前文件内模糊搜索

在 Telescope 窗口中：

- `<C-j>` / `<C-k>` — 上/下移动选择

依赖 `ripgrep`、`fd`，由 `extraPackages` 自动安装。

### LSP（语言服务器）

自动启用的 LSP 服务器：

- `nixd` + `nil_ls` — Nix
- `lua_ls` — Lua
- `ts_ls` — TypeScript / JavaScript / JSX / TSX
- `rust_analyzer` — Rust
- `gopls` — Go
- `marksman` — Markdown
- `bashls` — Bash
- `html` / `cssls` / `jsonls` — Web

LSP 快捷键（仅在 LSP 附着的缓冲区生效）：

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gr` | 查找引用 |
| `gi` | 跳转到实现 |
| `gt` | 跳转到类型定义 |
| `K` | 悬浮文档 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作（快速修复等） |
| `<leader>cl` | Code Lens 操作 |
| `[d` | 上一个诊断 |
| `]d` | 下一个诊断 |
| `<leader>e` | 诊断详情浮窗 |

内联提示（inlay hints）默认开启。

### 代码补全 — nvim-cmp

补全来源：LSP、LuaSnip 代码片段、路径、缓冲区。

| 快捷键 | 功能 |
|--------|------|
| `<C-j>` / `<C-k>` | 上/下选择补全项 |
| `<C-b>` / `<C-f>` | 文档上/下滚动 |
| `<C-Space>` | 触发补全 |
| `<C-e>` | 关闭补全菜单 |
| `<CR>` / `<Tab>` | 确认当前选择 |

### 自动格式化 — conform.nvim

保存时自动调用对应格式化器。格式化器映射：

| 文件类型 | 格式化器 |
|----------|----------|
| Nix | nixfmt |
| Lua | stylua |
| Rust | rustfmt |
| Go | gofumpt, goimports |
| JavaScript/TypeScript/JSX/TSX | prettierd, prettier |
| HTML/CSS/SCSS/JSON/Markdown/YAML | prettierd |
| TOML | taplo |
| Bash/Shell | shfmt |

**用户命令**：

- `:FormatDisable` — 全局禁用自动格式化
- `:FormatDisable!` — 仅当前缓冲区禁用
- `:FormatEnable` — 重新启用
- `<leader>cf` — 手动格式化当前文件

### Git 集成

- `<leader>gg` — 打开 Neogit（类 Magit 的 Git 状态面板）
- `<leader>gb` — 显示当前行的 Git Blame
- `<leader>gd` — 打开 Diffview（差异对比视图）

Gitsigns 在行号左侧显示增删改标记，并启用当前行 Blame。

### 终端

终端区域位于编辑区正下方（`:below split` 对齐），以一条细分割线与编辑区隔开。

- `<leader>tt` — 切换底部终端（打开 / 关闭）
- `<Esc>` — 终端插入 → 正常模式（`t` 模式）

**终端模式下的窗格切换**（Ctrl+方向键，不干扰终端字符输入，无需先按 `<Esc>`）：

| 快捷键 | 功能 |
|--------|------|
| `<C-Left>` | 终端 → 左窗格（文件树） |
| `<C-Down>` | 终端 → 下窗格 |
| `<C-Up>` | 终端 → 上窗格（编辑区） |
| `<C-Right>` | 终端 → 右窗格 |

终端不显示底部状态栏（lualine 排除 `fterm`）、不列入编辑器标签栏（`buflisted=false`）。

### UI 增强

- **lualine** — 全局底部状态栏（`globalstatus=true`），Catppuccin 主题，始终显示不随窗口变化
- **bufferline** — 顶部标签栏，缩略分隔符样式，终端 buffer 自动排除
- **which-key** — 按键后 400ms 弹出快捷键提示（modern 预设）
- **noice** — 命令行美化 + LSP 文档边框 + 长消息自动分割
- **alpha** — 启动页（dashboard 主题），显示 ASCII 艺术和快捷入口
- **indent-blankline** — 缩进引导线（作用域线已禁用，部分文件类型排除）
- **todo-comments** — 高亮 `TODO` / `FIX` / `HACK` / `WARN` / `PERF` / `NOTE` / `TEST` 注释
- **rainbow-delimiters** — 彩虹括号
- **nvim-autopairs** — 自动配对括号、引号
- **comment.nvim** — 智能注释切换（`gcc` 注释当前行，`gc` + 动作注释选中区域）

### Treesitter

精确安装的语法解析器：

```
bash, c, comment, css, dockerfile, git_config, git_rebase,
gitattributes, gitcommit, gitignore, go, gomod, gowork,
html, javascript, json, lua, markdown, markdown_inline,
nix, python, rust, scss, toml, typescript, vim, vimdoc, yaml
```

功能：语法高亮 + 缩进 + 增量选择 + 文本对象。

Treesitter 增量选择：`<CR>` 扩大选择范围，`<BS>` 缩小。

### 窗口与缓冲区管理

窗格切换统一使用 Ctrl+方向键，普通模式和终端模式均可用，终端中无需先按 `<Esc>`。

| 快捷键 | 功能 |
|--------|------|
| `<C-Left>` | 聚焦左窗格 |
| `<C-Down>` | 聚焦下窗格 |
| `<C-Up>` | 聚焦上窗格 |
| `<C-Right>` | 聚焦右窗格 |
| `<leader>sv` | 垂直分割 |
| `<leader>sh` | 水平分割 |
| `<S-l>` | 下一个缓冲区 |
| `<S-h>` | 上一个缓冲区 |
| `<leader>x` | 关闭当前缓冲区 |
| `<leader>w` | 保存 |
| `<leader>q` | 关闭当前分窗（仅关窗口，不退出编辑器） |
| `<leader>Q` | 退出编辑器（3 秒内连按两次确认） |
| `<Esc>` | 清除搜索高亮 |

## 自动命令

- **Yank 高亮**：复制文本后高亮 200ms
- **尾随空白清理**：保存时自动删除行尾空格（Markdown 文件除外）

---

## 架构说明

配置分为三层：

1. **nixvim 模块选项**（主体）：插件启用、主题、编辑器选项、LSP 服务器、快捷键——全部用 Nix 属性声明
2. **`grammarPackages`**：Treesitter 语法包精确列举（而非 `withAllGrammars` 全部安装）
3. **`extraConfigLua`**（兜底）：底部终端管理、用户命令、自动命令——nixvim 没有对应结构化选项的逻辑才放在这里

添加新插件的模式：

```nix
plugins.<name> = {
  enable = true;
  settings = { /* Lua setup() 参数原样翻译为 Nix */ };
};
```

修改快捷键：编辑 `keymaps` 列表或对应插件的 `keymaps` 子属性。修改后运行 `home-manager switch` 即生效。
