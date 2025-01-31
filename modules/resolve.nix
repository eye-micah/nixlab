{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ davinci-resolve ];
  qt.enable = false; # Currently needed for the damn thing to launch. Not even questioning it.
}
