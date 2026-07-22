{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    pkgs.maple-mono.NF-unhinted

    material-symbols
  ];
}
