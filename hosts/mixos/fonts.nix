{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    (pkgs.stdenv.mkDerivation {
      pname = "MapleMono-NF-unhinted";
      version = "8.0b2";

      src = pkgs.fetchFromGitHub {
        owner = "subframe7536";
        repo = "maple-font";
        rev = "variable";
        hash = "sha256-PnHTFH8qU9aZHvfuRnI7/jkCyTgSNykCqSB2jqIws7M=";
      };

      nativeBuildInputs = with pkgs.python3Packages; [
        py7zr
        fontmake
        ttfautohint-py
      ];

      buildPhase = ''
        python3 build.py --no-hinted
      '';
      installPhase = ''
        find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
        find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
        find . -name '*.woff2'  -exec install -Dt $out/share/fonts/woff2 {} \;
      '';
    })

    material-symbols
  ];
}
