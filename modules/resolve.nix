{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ davinci-resolve shutter-encoder ];
}
