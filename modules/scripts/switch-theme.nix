{pkgs, ...}:
pkgs.writeShellApplication {
  name = "switch-theme";
  runtimeInputs = with pkgs; [gnused coreutils home-manager];
  text = ''
    generation_index=1

    while true
    do
      generation=$(home-manager generations | sed -n "''${generation_index}p" | sed 's/.*-> //')

      if [ -d "$generation/specialisation" ]; then
        echo "$generation"

        eval "$generation/specialisation/theme-$1/activate"
        break
      fi

      ((generation_index++))
    done
  '';
}
