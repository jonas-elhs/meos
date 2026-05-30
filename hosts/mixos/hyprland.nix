{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.wrappers-hyprland.wrappers.hyprland.wrap {
      inherit pkgs;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      configFile = ../../dotfiles/hyprland.lua;

      plugins = [
        inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
        # inputs.my-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprlandPlugins.hyprcapture
      ];
    };
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
