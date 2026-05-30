# layout = {
#   border = {
#     width = "2";
#     radius = {
#       size = "10";
#       inner = "7";
#     };
#   };
#   font = {
#     name = "MapleMono Nerd Font Propo";
#     mono = "MapleMono Nerd Font Mono";
#     sub = "10";
#     size = "12";
#     title = "18";
#   };
#   background = {
#     opacity = 0.4;
#     opacity_hex = "66";
#   };
#   gap = {
#     size = "20";
#     inner = "10";
#   };
#   # css: filter: blur(calc(size * sqrt(passes) * 0.85px));
#   blur = {
#     size = "5";
#     passes = "4";
#   };
# };
{
  pkgs,
  config,
  my-nixpkgs,
  ...
}: {
  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
    QT_QPA_PLATFORM = "wayland";
  };

  qt.enable = true;
  programs.nix-ld.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = config.preferences.hostname;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (final: prev: {
        hyprlandPlugins.hyprcapture = my-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprlandPlugins.hyprcapture;
      })
    ];
  };

  system.stateVersion = "24.11";
}
