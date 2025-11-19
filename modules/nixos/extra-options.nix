{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    system.architecture = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "The system architecture";
    };
    config-root = lib.mkOption {
      type = lib.types.str;
      description = "An absolute path to the flakes root directory.";
    };
  };
}
