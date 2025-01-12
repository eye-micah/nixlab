{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.tmux
    pkgs.vim
    pkgs.btop
    pkgs.zsh
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.fira-code
  ];

  # Platform-specific adjustments
#  platformSpecificPackages = if system == "darwin" then
#    [ pkgs.zenity ] # Example of a macOS-only package
#  else
#    [ pkgs.git ];   # Example of a Linux-only package

  home.username = "micah";

#  home.homeDirectory = if system == "darwin" then
#    "/Users/micah"
#  else
#    "/home/micah";

  programs.home-manager.enable = true;

  home.file.".ssh/config".text = ''
    Host *
      ForwardAgent no
      AddKeysToAgent no
      Compression no
      ServerAliveInterval 0
      ServerAliveCountMax 3
      HashKnownHosts no
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      ControlMaster no
      ControlPath ~/.ssh/master-%r@%n:%p
      ControlPersist no
  '';

  # Zsh
  ## Link the actual zshrc from the Nix folder

  home.file.".zshenv".source = ./dotfiles/zshenv;
  #home.file.".zshrc".source = ./dotfiles/zshrc;
  #home.file.".zsh_plugins.txt".source = ./dotfiles/zsh_plugins.txt;
  home.file.".vimrc".source = ./dotfiles/vimrc;
  home.file.".p10k.zsh".source = ./dotfiles/p10k.zsh;

  # Enable Zsh shell for the user
  programs.zsh = {
    enable = true;

    # Set the desired options and configurations
    shellAliases = {
      rm = "rm -i";
      switch = "darwin-rebuild switch --flake ~/git/nix-infra/home-manager/clients";
    };

    # Additional environment variables
    initExtra = ''

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      export WINEFSYNC=1
      export WINEESYNC=1
      export HOMEBREW_NO_ANALYTICS=1
      export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

      # Custom PATH setup (adjust as needed)
      export PATH=/opt/homebrew/bin/:$HOME/.local/bin:/opt/local/bin:$HOME/Library/Python/3.9/bin:/usr/sbin:/sbin:$PATH

      # Autoload functions
      autoload -Uz bracketed-paste-magic
      zle -N bracketed-paste bracketed-paste-magic

      autoload -Uz url-quote-magic
      zle -N self-insert url-quote-magic

      # Extended glob setting
      setopt extended_glob
    '';

    antidote = {
      enable = true;
      plugins = [''
        romkatv/powerlevel10k
        zsh-users/zsh-autosuggestions
        zsh-users/zsh-history-substring-search
        zsh-users/zsh-syntax-highlighting
        rupa/z
      '']; 
    };

  };




}


