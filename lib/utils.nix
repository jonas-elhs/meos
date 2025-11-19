{
  hosts,
  paths,
  nixpkgs,
  ...
}: let
  lib = nixpkgs.lib;
in rec {
  getPkgs = system: nixpkgs.legacyPackages.${system};

  getSystem = host: hosts.${host}.system;

  getSystemPkgs = host: getPkgs (getSystem host);

  getDirNames = (
    dir:
      builtins.filter
      (file: !(lib.hasPrefix "_" file) && !(lib.hasPrefix "." file))
      (builtins.attrNames (builtins.readDir dir))
  );

  getModuleConfig = modulePath:
    (import modulePath) {
      inputs = null;
      config = null;
      lib = null;
      pkgs = null;
      libx = null;
    };

  isHomeManagerEnabled = host: (getModuleConfig (paths.hostFile host)).home-manager.enable == true;

  listPaths = (
    dir:
      lib.flatten (
        lib.forEach
        (getDirNames dir)
        (
          name:
            if lib.hasSuffix ".nix" name
            then /${dir}/${name}
            else (listPaths /${dir}/${name})
        )
      )
  );

  getUserGroups = host: user: (getModuleConfig (paths.userFile host user)).home.groups;

  stringDivide = string_dividend: int_divisor: (toString ((lib.toInt string_dividend) / int_divisor));
}
