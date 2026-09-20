{
  pkgs,
  inputs,
  wrappers,
  ...
}: let
  hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = with pkgs; [
    xdg-utils
    grim
    ffmpeg
    gpu-screen-recorder
  ];
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = wrappers.hyprland.wrap {
      inherit pkgs;

      package = hyprlandPackages.hyprland;
      configFile = ../../dotfiles/hyprland.lua;
      lua.dirs = ["/home/jonas/.config/hypr"];
      disableConfigValidation = true;

      plugins = [
        (pkgs.stdenv.mkDerivation {
          pname = "hyprglass";
          version = "git";
          src = inputs.hyprglass;

          buildInputs = [hyprlandPackages.hyprland] ++ hyprlandPackages.hyprland.buildInputs;
          nativeBuildInputs = [pkgs.pkg-config];

          installPhase = ''
            install -Dm755 hyprglass.so $out/lib/libhyprglass.so
          '';
        })
        inputs.hyprcapture.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      ];
    };
    portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland;
  };
}
