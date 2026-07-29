# Treesitter 语法高亮
{
  pkgs,
  ...
}: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<CR>";
            node_incremental = "<CR>";
            node_decremental = "<BS>";
          };
        };
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        comment
        css
        dockerfile
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gomod
        gowork
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        python
        rust
        scss
        toml
        typescript
        vim
        vimdoc
        yaml
      ];
    };

    treesitter-textobjects.enable = true;
  };
}
