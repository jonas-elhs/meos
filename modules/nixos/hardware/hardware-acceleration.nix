{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hardware-acceleration;
in {
  options.hardware-acceleration = {
    enable = lib.mkEnableOption "Hardware Acceleration";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
