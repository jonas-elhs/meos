{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    google-cursor
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "GoogleDot-White";
    XCURSOR_SIZE = 22;
  };
}
