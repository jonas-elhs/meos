{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.home-manager;
in {
  options.home-manager = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Home Manager.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      home-manager
    ];
  };
}
