{
  description = "Jonas NixOS";

  inputs = {
    nixpkgs.url = "path:/home/jonas/dev/nixpkgs";
    # nixpkgs.url = "github:NixOS/nixpkgs";

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers-ghostty = {
      url = "github:TrustworthyAdult/nix-wrapper-modules";
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
      url = "path:/home/jonas/dev/metemplate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    nixpkgs,
    wrappers,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    shouldImport = file:
      !lib.hasPrefix "_" file.name;
    importTree = path:
      toList (fileFilter shouldImport path);

    pkgs = nixpkgs.legacyPackages.${system};

    host = "mixos";
    user = "jonas";
    system = "x86_64-linux";
  in {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs wrappers;};
      modules = lib.flatten [
        (importTree ./hosts/${host})

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
