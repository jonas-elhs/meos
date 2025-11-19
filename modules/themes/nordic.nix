rec {
  # DEFINTIONS #
  background = {
    dark = black.dim;
    base = gray.dark;
    light = gray.base;
  };

  foreground = {
    dark = gray.light;
    base = white.dark;
    light = white.light;
  };

  accent = cyan.dim;
  inactive = gray.bright;

  success = green.dim;
  error = red.dim;

  url = blue.bright;
  cursor = white.dark;

  gradient2 = [yellow.base green.base];
  gradient3 = [yellow.base blue.base magenta.base];
  gradient4 = [yellow.base green.base blue.base magenta.base];
  gradient5 = [orange.base yellow.base green.base blue.base magenta.base];
  gradient6 = [orange.base yellow.base green.base cyan.base blue.base magenta.base];
  gradient7 = [orange.base yellow.base green.bright green.base cyan.base blue.base magenta.base];
  gradient8 = [red.base orange.base yellow.base green.bright green.base cyan.base blue.base magenta.base];
  gradient9 = [red.base orange.base yellow.base green.bright green.base cyan.base blue.base blue.dim magenta.base];

  base00 = black.dim;
  base08 = gray.base;
  base01 = red.base;
  base09 = red.bright;
  base02 = green.base;
  base0A = green.bright;
  base03 = yellow.base;
  base0B = yellow.bright;
  base04 = blue.base;
  base0C = blue.bright;
  base05 = magenta.base;
  base0D = magenta.bright;
  base06 = cyan.base;
  base0E = cyan.bright;
  base07 = white.dim;
  base0F = white.base;

  # COLORS #
  black = {
    dim = "#191D24";
    base = "#1E222A";
    bright = "#222630";
  };
  gray = {
    dark = "#242933";
    dim = "#2E3440";
    base = "#3B4252";
    light = "#434C5E";
    bright = "#4C566A";
  };
  white = {
    dark = "#C0C8D8";
    dim = "#D8DEE9";
    base = "#E5E9F0";
    light = "#ECEFF4";
  };
  blue = {
    dim = "#5E81AC";
    base = "#81A1C1";
    bright = "#88C0D0";
  };
  cyan = {
    dim = "#80B3B2";
    base = "#8FBCBB";
    bright = "#9FC6C5";
  };
  red = {
    dim = "#B74E58";
    base = "#BF616A";
    bright = "#D06F79";
  };
  orange = {
    dim = "#CB775D";
    base = "#D08770";
    bright = "#D79784";
  };
  yellow = {
    dim = "#E7C173";
    base = "#EBCB8B";
    bright = "#F0D399";
  };
  green = {
    dim = "#97B67C";
    base = "#A3BE8C";
    bright = "#B1C89D";
  };
  magenta = {
    dim = "#A97EA1";
    base = "#B48EAD";
    bright = "#BE9DB8";
  };
}
