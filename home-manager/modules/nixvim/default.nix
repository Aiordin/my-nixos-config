# nixvim 配置入口，按功能拆分为子模块
{
  imports = [
    ./theme.nix
    ./options.nix
    ./ui.nix
    ./files.nix
    ./treesitter.nix
    ./lsp.nix
    ./completion.nix
    ./git.nix
    ./formatting.nix
    ./editing.nix
    ./terminal.nix
    ./keymaps.nix
    ./lua.nix
  ];
}
