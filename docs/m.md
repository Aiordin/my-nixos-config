# 备忘录 / 杂项

## Devbox + direnv

```bash
# 初始化项目
cd my-project && devbox init

# 添加包
devbox add go@latest nodejs python

# 生成 direnv 配置
devbox generate direnv
direnv allow

# 查看已安装的包
devbox info

# 更新 lock 文件
devbox update
```

## Neovim

### 新增模块（2026-07-30）

- **fidget.nix** — LSP 进度右下角通知
- **trouble.nvim** — 诊断列表面板（`<leader>dd`）
- **cmp-cmdline** — 命令行/搜索补全
- **mini.surround** — surround 操作（sa/sd/sr）
- **telescope-fzf-native** — 更快排序

### 新增快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>y` | 复制到系统剪贴板 |
| `<leader>s>` / `<` / `+` / `-` | 调整窗格大小 |
| `<leader>dd` / `db` / `dl` / `dq` | Trouble 诊断面板 |
| `sa` / `sd` / `sr` | surround 操作 |

## 常用 Nix 命令

```bash
# 更新 flake 锁定版本
nix flake update

# 查看已安装的 home-manager 代
home-manager generations

# 回退到上一个代
home-manager switch --rollback

# 清理旧代（保留最近 7 天）
nix-collect-garbage --delete-older-than 7d

# 清理所有未使用的路径
nix-collect-garbage -d
```
