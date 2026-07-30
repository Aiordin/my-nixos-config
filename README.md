# nix-config

基于 Nix Flake 的 NixOS + Home Manager 配置，声明式管理整个系统环境。

## 结构

```
nix-config/
├── flake.nix                  # Flake 入口，定义输入和输出
├── nixos/
│   ├── configuration.nix      # NixOS 系统配置（桌面、网络、硬件等）
│   └── modules/               # 系统级模块
│       ├── desktop.nix        # 桌面环境（niri + waybar）
│       ├── stylix.nix         # 全局主题（Catppuccin Mocha）
│       ├── fonts.nix          # 字体
│       ├── fcitx5.nix         # 中文输入法
│       ├── flatpak.nix        # Flatpak 支持
│       ├── docker.nix         # Docker
│       └── ...
├── home-manager/
│   ├── home.nix               # Home Manager 入口
│   └── modules/
│       ├── nixvim/            # Neovim 配置（14 个子模块）
│       ├── niri/              # niri 窗口管理器
│       ├── waybar/            # 状态栏
│       ├── eww/               # Elkowar's Wacky Widgets
│       ├── devbox.nix         # Devbox + direnv
│       ├── programs.nix       # 终端工具和基础程序
│       └── ...
└── docs/
    ├── nixvim.md              # Neovim 配置详解
    └── m.md                   # 备忘录
```

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/Aiordin/nix-config.git
cd nix-config

# 应用系统配置
sudo nixos-rebuild switch --flake .#nixos

# 应用用户配置（首次）
home-manager switch --flake .#kid@nixos
```

## 主要特性

### Devbox + direnv — 项目级隔离开发环境

每个项目可以拥有独立的开发环境，进入目录时自动激活，离开时自动卸载。

```bash
cd my-project
devbox init                  # 初始化
devbox add go@latest nodejs  # 添加依赖
devbox generate direnv        # 生成 .envrc
direnv allow                  # 信任配置
# 之后每次 cd 进入该目录即自动激活环境
```

详情见 `home-manager/modules/devbox.nix`。

### Neovim — 声明式 IDE 配置

14 个模块、40+ 个插件、完整的 LSP 支持。覆盖 Nix/Lua/TS/Rust/Go/Python/Docker 等多种语言。

- **主题**：Catppuccin Mocha
- **LSP**：自动补全、跳转、悬浮文档、诊断面板（Trouble）
- **格式化**：保存时自动格式化（conform.nvim）
- **Git**：行内变更标记 + 交互式面板 + 差异审查
- **搜索**：Telescope + fzf-native
- **快捷键**：Space 作为 leader，which-key 菜单提示

完整文档：[docs/nixvim.md](docs/nixvim.md)

## 更新配置

```bash
cd nix-config
# 拉取最新
git pull
# 应用
home-manager switch --flake .#kid@nixos
sudo nixos-rebuild switch --flake .#nixos  # 如果系统配置也有变动
```
