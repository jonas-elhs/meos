{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.XXX;
in {
  options.XXX = {
    enable = lib.mkEnableOption "XXX";
  };

  config =
    lib.mkIf cfg.enable {
    };
}
