{ ... }:
{
  programs.nixvim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;
      plugins = {
        nix.enable = true;
      };
  };
}
