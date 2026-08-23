{
  pkgs,
  inputs,
  ...
}: let
  hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
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

      package = hyprlandPackages.hyprland;
      configFile = ../../dotfiles/hyprland.lua;
      disableConfigValidation = true;

      plugins = [
        (pkgs.stdenv.mkDerivation {
          pname = "hyprglass";
          version = "0.7.0";

          src = inputs.hyprglass;
          buildInputs = [hyprlandPackages.hyprland] ++ hyprlandPackages.hyprland.buildInputs;
          nativeBuildInputs = [pkgs.pkg-config];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/lib
            mv hyprglass.so "$out/lib/libhyprglass.so"

            runHook postInstall
          '';
        })
        inputs.hyprcapture.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      ];
    };
    portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland;
  };
}
