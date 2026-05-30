{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    (callPackage ../../packages/maple-nerd-font-mono.nix {})
    (callPackage ../../packages/maple-nerd-font-propo.nix {})

    material-symbols
  ];
}
