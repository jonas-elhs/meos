{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.bluetooth;
in {
  options.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
