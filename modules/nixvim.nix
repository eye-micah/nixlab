{ pkgs, ... }:
{
  programs.nixvim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      opts = {
        number = true;
      };
      clipboard.register = "unnamedplus";
      plugins = {
        nix.enable = true;
        cmp-fuzzy-path.enable = true;
        nvim-tree.enable = true;
        auto-save.enable = true;
        presence-nvim.enable = true;
        rainbow-delimiters.enable = true;
        rainbow-delimiters.highlight = [
          "RainbowDelimiterBlue"
          "RainbowDelimiterGreen"
          "RainbowDelimiterViolet"
          "RainbowDelimiterCyan"
        ];
        fugitive.enable = true;
        fzf-lua.enable = true;
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings.sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
        treesitter = {
          enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            json
            lua
            make
            markdown
            nix
            regex
            toml
            vim
            vimdoc
            xml
            yaml
          ];
      };
    };
  };
}
