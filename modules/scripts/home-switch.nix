{
  pkgs,
  config,
  ...
}:
pkgs.writeShellApplication {
  name = "home-switch";
  text = ''
    SKIP_SANITY_CHECKS=1 sudo -E home-manager switch --flake "${config.config-root}#$(whoami)@$(hostname)"
  '';
}
