{
  utils,
  hosts,
  paths,
  nixpkgs,
  ...
}: let
  lib = nixpkgs.lib;
in rec {
  # Read Hosts and Users
  _getUsersFromHost = (
    host:
      lib.flatten
      (
        lib.forEach
        (utils.getDirNames (paths.usersDir host))
        (userFile: lib.take 1 (lib.splitString "." userFile))
      )
  );
  getHosts = builtins.listToAttrs (
    lib.forEach
    (utils.getDirNames paths.hostsDir)
    (host: {
      name = host;
      value = {
        users = _getUsersFromHost host;
        system = (utils.getModuleConfig (paths.hostFile host)).system.architecture;
      };
    })
  );

  # NixOS
  getHostNames = builtins.attrNames hosts;
  forEachHost = f: nixpkgs.lib.genAttrs getHostNames f;

  # Home Manager
  _forEachUserInHost = (
    host: f:
      lib.forEach
      hosts.${host}.users
      (user: {
        name = "${user}@${host}";
        value = f user;
      })
  );
  forEachHome = (
    f:
      builtins.listToAttrs (
        lib.flatten (
          lib.mapAttrsToList
          _forEachUserInHost
          (lib.filterAttrs (name: value: utils.isHomeManagerEnabled name) (forEachHost f))
        )
      )
  );

  # Scripts
  getScripts = (
    system: config:
      lib.forEach
      (utils.getDirNames paths.scriptsDir)
      (script: (import (paths.scriptFile script) {
        pkgs = utils.getPkgs system;
        inherit config;
      }))
  );

  # Packages
  getPackages = (
    system:
      builtins.listToAttrs
      (
        lib.forEach
        (utils.getDirNames paths.packagesDir)
        (package: {
          name = lib.elemAt (lib.splitString "." package) 0;
          value = (utils.getPkgs system).callPackage (paths.packagesFile package) {};
        })
      )
  );
}
