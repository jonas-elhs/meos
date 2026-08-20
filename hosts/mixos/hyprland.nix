{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    grim
    ffmpeg
    gpu-screen-recorder
  ];
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.wrappers-hyprland.wrappers.hyprland.wrap {
      inherit pkgs;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      configFile = ../../dotfiles/hyprland.lua;
      disableConfigValidation = true;

      plugins = [
        # inputs.hyprcapture.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      ];
    };
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
