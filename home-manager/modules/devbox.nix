# Devbox + direnv — 项目级隔离开发环境
# Devbox 利用 Nix 为每个项目创建可复现的开发环境
# direnv 在进入目录时自动激活环境，离开时自动卸载
{ pkgs, ... }:
{
  # direnv — 目录级环境变量自动加载/卸载
  programs.direnv = {
    enable = true;

    # nix-direnv 集成：使用 Nix 的求值缓存，大幅加速 direnv 加载
    # 避免每次 cd 都重新评估 flake.nix 或 shell.nix
    nix-direnv.enable = true;

    # 静默模式：减少 direnv 的输出噪音
    silent = true;
  };

  # Devbox — Jetify 的 Nix 驱动开发环境管理器
  # 使用方式：
  #   1. devbox init           — 初始化项目环境
  #   2. devbox add go nodejs  — 添加依赖
  #   3. devbox shell          — 进入开发 shell
  #   4. devbox generate direnv — 生成 .envrc（配合 direnv 自动激活）
  #
  # 典型项目根目录结构：
  #   devbox.json  — 声明依赖和脚本
  #   devbox.lock  — 锁定版本
  #   .envrc       — direnv 配置（内含 'use devbox'）
  home.packages = with pkgs; [
    devbox
  ];

  # 为 direnv 全局添加 .envrc 允许规则
  # 这样在任意项目中，只要 .envrc 是由 devbox generate direnv 生成的就自动信任
  programs.bash.initExtra = ''
    # direnv hook（Home Manager 会自动配置 bash/zsh/fish 的 hook）
    # 此处仅作备用，HM 的 programs.direnv.enable 已覆盖主要 shell
  '';
}
