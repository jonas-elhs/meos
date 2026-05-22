{
  lib,
  config,
  ...
}: let
  cfg = config.anki;
in {
  options.anki = {
    enable = lib.mkEnableOption "Anki";
  };

  config = lib.mkIf cfg.enable {
    programs.anki = {
      enable = true;
      language = "en_US";
      profiles."User 1" = {
        sync = {
          usernameFile = "/home/jonas/nixos/secrets/anki-username.txt";
          keyFile = "/home/jonas/nixos/secrets/anki-sync-key.txt";
        };
      };
    };
  };
}
