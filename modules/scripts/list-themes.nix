{pkgs, ...}:
pkgs.writeShellApplication {
  name = "list-themes";
  runtimeInputs = with pkgs; [gnused coreutils home-manager];
  text = ''
    generation_index=1

    while true
    do
      generation=$(home-manager generations | sed -n "''${generation_index}p" | sed 's/.*-> //')

      if [ -d "$generation/specialisation" ]; then
        # shellcheck disable=SC2012
        specialisations=$(ls "$generation/specialisation" | sed "s/theme-//g")
        echo "$specialisations"
        break
      fi

      ((generation_index++))
    done
  '';
}
