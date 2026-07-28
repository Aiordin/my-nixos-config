{ pkgs,... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    material-symbols
    noto-fonts-cjk-sans
  ];
}
