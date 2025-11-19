{
  pkgs,
  config,
  ...
}:
pkgs.writeShellApplication {
  name = "nixos-switch";
  text = ''
    sudo nixos-rebuild switch --flake ${config.config-root}
  '';
}
