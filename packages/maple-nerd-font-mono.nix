{
  stdenv,
  nerd-font-patcher,
  maple-mono,
}:
stdenv.mkDerivation {
  name = "${maple-mono.truetype.name}-nerd-font-mono";
  src = maple-mono.truetype;
  nativeBuildInputs = [nerd-font-patcher];
  buildPhase = ''
    find \( -name \*.ttf -o -name \*.otf \) -execdir nerd-font-patcher --mono -c {} \;
  '';
  installPhase = "cp -a . $out";
}
