{ ... }:
{
  programs.nixvim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = {
        nix.enable = true;
        #presence.nvim.enable = true;
      };
  };
}
