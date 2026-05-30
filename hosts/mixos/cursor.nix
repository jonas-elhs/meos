# TODO: try googledot-black pkgs.google-cursor
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    phinger-cursors
  ];
  environment.sessionVariables = {
    XCURSOR_THEME = "phinger-cursors-dark";
    XCURSOR_SIZE = 24;
  };
}
