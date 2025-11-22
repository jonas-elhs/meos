{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.anki;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.anki = {
    enable = lib.mkEnableOption "Anki";
  };

  config = lib.mkIf cfg.enable {
    programs.anki = {
      enable = true;
      language = "en_US";
      sync = {
        usernameFile = "/home/jonas/nixos/secrets/anki-username.txt";
        keyFile = "/home/jonas/nixos/secrets/anki-sync-key.txt";
      };
    };
  };
}
