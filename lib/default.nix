{
  hosts,
  paths,
  nixpkgs,
  ...
}: let
  utils = import ./utils.nix {inherit hosts paths nixpkgs;};
  flake = import ./flake.nix {inherit utils hosts paths nixpkgs;};
in
  utils // flake
