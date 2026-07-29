# 主题 / colorscheme
{
  ...
}: {
  programs.nixvim.colorschemes.catppuccin = {
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
}
