# darwin.nix

{ pkgs, ... }:

{
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
    [ pkgs.vim ];

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true;  # default shell on catalina
    # programs.fish.enable = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    users.users.micah = {
        name = "micah";
        home = "/Users/micah";
    };

    homebrew = {
      enable = true;
      casks = [
        "firefox"
        "iterm2"
        "bitwarden"
        "alfred"
        "google-chrome"
        "tailscale"
        "parsec"
        "rectangle"
        "alt-tab"
        "obs"
        "shutter-encoder"
        "iina"
        "qbittorrent"
        "localsend"
        "copyclip"
        "zed"
      ];
    };
}