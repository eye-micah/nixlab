{ lib, inputs, config, pkgs, ... }:
{

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
      ];
    };
  };


  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.stateVersion = lib.mkDefault "24.11";

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

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Micah Daniel";
    userEmail = "micah@micah.com";
    extraConfig = {
      core.editor = "nvim";   
      color.ui = "auto";
      diff = {
        tool = "nvim -d";
        mnemonicprefix = true;
      };
    };
  };


  home.file = lib.mkMerge [

    # SSH Configuration
    {
      ".ssh/config".text = ''
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
    }

    # Zsh and Fonts Configurations
    {
      ".zshenv".source = ../dotfiles/zshenv;  # Correctly reference external files with 'source'
      ".p10k.zsh".source = ../dotfiles/p10k.zsh;
      ".local/share/fonts/avenir.ttf".source = ../dotfiles/fonts/avenir;
      ".local/share/fonts/didot.ttf".source = ../dotfiles/fonts/didot;
    }
  ];

  # Enable Zsh shell for the user
  programs.zsh = {
    enable = true;

    # Set the desired options and configurations
    shellAliases = {
      rm = "rm -i";
      nix-shell="nix-shell --run $SHELL";
    };

    # Additional environment variables
    initExtra = ''

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      export WINEFSYNC=1
      export WINEESYNC=1
      export HOMEBREW_NO_ANALYTICS=1
      export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
      export EDITOR=nvim
      export GIT_EDITOR=nvim
      export VISUAL=nvim

      # Custom PATH setup (adjust as needed)
      export PATH=/opt/homebrew/bin/:$HOME/.local/bin:/opt/local/bin:$HOME/Library/Python/3.9/bin:/usr/sbin:/sbin:$PATH

      # Extended glob setting
      setopt extended_glob

      switch() {
        # Autodetect the directory where the flake is stored (assuming it's the current directory)
        local flake_dir="$(pwd)"
        
        # IP of the saejima build node
        local build_host="192.168.1.235"
        local target_host="localhost"  # Default target host (local machine)

        # Check if the build node is reachable (ping the build host)
        if ping -c 1 "$build_host" &>/dev/null; then
          echo "Build host $build_host is up. Using it as a build host."
          local build_host_option="--build-host micah@$build_host"
        else
          echo "Build host $build_host is not reachable. Proceeding with the local build."
          local build_host_option=""
        fi

        # Detect the target host (if needed, you can modify this to dynamically select a remote target host)
        # In this case, it's defaulting to local unless otherwise specified

        # Check if we're on macOS, NixOS, or a non-NixOS Linux system
        if [[ "$(uname)" == "Darwin" ]]; then
            darwin-rebuild switch --flake "$flake_dir"/#haruka 

        elif [[ -d /etc/nixos ]]; then
          # For NixOS (checks for /etc/nixos directory)
          nixos-rebuild switch --build-host micah@192.168.1.246 --flake "$flake_dir"/#$(cat /etc/hostname)

        else
          # For non-NixOS Linux (using home-manager)
          home-manager switch --flake "$flake_dir"/.#$(cat /etc/hostname)
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
