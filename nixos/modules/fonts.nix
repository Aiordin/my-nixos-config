{ pkgs,... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    material-symbols
    noto-fonts-cjk-sans
    liberation_ttf # Steam 和许多 Linux 应用所需的通用拉丁字体（Arial/Times/Courier 替代）
  ];
}
