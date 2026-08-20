{
  fileSystems."/nix".neededForBoot = true;

  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=50%"
          "mode=755"
        ];
      };
    };

    disk.main = {
      device = "/dev/disk/by-id/nvme-CT2000T700SSD5_2335E8709249";
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          swap = {
            size = "64G";

            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          root = {
            name = "root";
            size = "100%";

            content = {
              type = "btrfs";
              extraArgs = ["-f"];

              subvolumes = {
                "/persistent" = {
                  mountOptions = ["subvol=persist" "noatime"];
                  mountpoint = "/persistent";
                };

                "/nix" = {
                  mountOptions = ["subvol=nix" "noatime"];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
