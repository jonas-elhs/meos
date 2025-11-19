{pkgs, ...}:
pkgs.writeShellApplication {
  name = "screenshot";
  runtimeInputs = with pkgs; [grim slurp wl-clipboard];
  text = ''
    grim -g "$(slurp -w 0)" - | wl-copy
  '';
}
