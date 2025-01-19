{ ... }:
{
  programs.nixvim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      opts = {
        number = true;
      };
      plugins = {
        nix.enable = true;
        #presence.nvim.enable = true;
      };
  };
}
