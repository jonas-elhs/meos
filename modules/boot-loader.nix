{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.boot-loader;
in {
  options.boot-loader = {
    systemd-boot.enable = lib.mkOption {
      default = true;
      example = false;
      description = "Wheter to enable systemd-boot Boot Manager";
      type = lib.types.bool;
    };
    grub = lib.mkEnableOption "Grub Boot Manager";

    timeout = lib.mkOption {
      default = 5;
      example = 0;
      description = "The timeout before the default boot entry gets booted";
      type = lib.types.int;
    };
    extraConfig = lib.mkOption {
      default = "";
      description = "Extra configuration options for the boot loader";
      type = lib.types.lines;
    };

    extraEntries = lib.mkOption {
      default = [];
      description = "Extra boot entries to add to the boot manager";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              description = "The name of the boot entry (file name)";
              type = lib.types.str;
            };
            title = lib.mkOption {
              description = "The title of the boot entry";
              type = lib.types.str;
            };
            efi = lib.mkOption {
              description = "The path to the efi file";
              type = lib.types.str;
            };
            sortKey = lib.mkOption {
              description = "The sort-key of the boot entry";
              type = lib.types.str;
            };
          };
        }
      );
    };
  };

  config = {
    boot.loader.timeout = cfg.timeout;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.systemd-boot = {
      enable = cfg.systemd-boot.enable;
      editor = false;
      extraEntries = lib.listToAttrs (
        lib.forEach cfg.extraEntries (
          entry: {
            name = "${entry.name}.conf";
            value = ''
              title ${entry.title}
              efi ${entry.efi}
              ${
                if entry.sortKey != null
                then "sort-key ${entry.sortKey}"
                else ""
              }
            '';
          }
        )
      );
      extraInstallCommands = builtins.concatStringsSep "\n" (lib.forEach (lib.splitString "\n" cfg.extraConfig) (line: "echo ${line} >> /boot/loader/loader.conf"));
    };
  };
}
