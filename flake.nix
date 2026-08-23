{
  description = "Jonas NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    preservation.url = "github:nix-community/preservation";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers-hyprland = {
      url = "github:jonas-elhs/nix-wrapper-modules/push-kpmnkpssnozs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers-hypridle = {
      url = "github:jonas-elhs/nix-wrapper-modules/hypridle/init";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    meshell = {
      url = "github:jonas-elhs/meshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.wrappers.follows = "wrappers";
    };
    mevim = {
      url = "github:jonas-elhs/mevim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.wrappers.follows = "wrappers";
    };
    metemplate = {
      url = "github:jonas-elhs/metemplate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprglass = {
      url = "path:/home/jonas/dev/hyprglass";
      flake = false;
    };
    hyprcapture = {
      url = "github:gfhdhytghd/HyprCapture/hyprland-master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland.follows = "hyprland";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs;
    inherit (nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    shouldImport = file:
      !lib.hasPrefix "_" file.name;
    importTree = path:
      toList (fileFilter shouldImport path);

    host = "mixos";
    user = "jonas";
  in {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit (inputs.wrappers) wrappers;
      };
      modules = lib.flatten [
        (importTree ./hosts/${host})

        inputs.disko.nixosModules.default
        inputs.preservation.nixosModules.default
        inputs.nix-index-database.nixosModules.default

        {
          options = {
            preferences = {
              hostname = lib.mkOption {
                type = lib.types.str;
                default = host;
              };
              username = lib.mkOption {
                type = lib.types.str;
                default = user;
              };
            };
          };
        }
      ];
    };
  };
}
