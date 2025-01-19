{ inputs, config, pkgs, pkgsUnstable, ... }:

{

  #imports = [
    #inputs.nixvim.homeManagerModules.nixvim
    # ];

  home.stateVersion = "24.11";
  home.packages = [
    pkgs.tmux
    # pkgs.vim
    pkgs.btop
    pkgs.zsh
    pkgs.fira-code-nerdfont
    pkgs.nixd
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


  home.file.".local/share/fonts/avenir.ttf".source = ./dotfiles/fonts/avenir;
  home.file.".local/share/fonts/didot.ttf".source = ./dotfiles/fonts/didot;

  # Enable Zsh shell for the user
  programs.zsh = {
    enable = true;

    # Set the desired options and configurations
    shellAliases = {
      rm = "rm -i";
      switch = "darwin-rebuild switch --flake '#haruka'";
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

      # Extended glob setting
      setopt extended_glob

      switch() {
        # Autodetect the directory where the flake is stored (assuming it's the current directory)
        local flake_dir="$HOME/git/nixlab"

        # Check if we're on macOS, NixOS, or a non-NixOS Linux system
        if [[ "$(uname)" == "Darwin" ]]; then
          # For macOS (Darwin)
          darwin-rebuild switch --flake "$flake_dir"

        elif [[ -d /etc/nixos ]]; then
          # More robust detection for NixOS (checks for /etc/nixos directory)
          nixos-rebuild switch --flake "$flake_dir"

        else
          # For non-NixOS Linux (using home-manager)
          home-manager switch --flake "$flake_dir"
        fi
      }
      
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
    enableCompletion = false;
  };

}
