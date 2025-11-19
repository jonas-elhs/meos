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

  # Themes
  _useAllThemes = (
    host: user:
      ((utils.getModuleConfig (paths.userFile host user)).theme.color.themes) == "all"
  );
  _getAllThemes = lib.remove "default.nix" (builtins.attrNames (builtins.readDir paths.themesDir));
  _getSpecifiedThemes = host: user: ((utils.getModuleConfig (paths.userFile host user)).theme.themes);
  _getThemeNames = (
    host: user:
      if (_useAllThemes host user)
      then _getAllThemes
      else _getSpecifiedThemes host user
  );
  getThemeSpecialisations = host: user:
    builtins.listToAttrs (
      lib.forEach
      (_getThemeNames host user)
      (file: let
        theme-name = builtins.toString (lib.take 1 (lib.splitString "." file));
      in {
        name = "theme-${theme-name}";
        value = {
          configuration = {
            theme.colors = import (paths.themesFile theme-name);
          };
        };
      })
    );
}
