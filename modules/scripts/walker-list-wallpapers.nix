{pkgs, ...}:
pkgs.writeShellApplication {
  name = "walker-list-wallpapers";
  text = ''
    Files=$(find -L ~/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \))

    while IFS= read -r path; do
      filename="''${path##*/}"
      base="''${filename%.*}"
      pretty=$(echo "$base" | sed 's/-/ /g' | sed 's/\b./\u&/g')

      echo "label=''$pretty;exec=wall $path;image=$path;recalculate_score=true;value=$path"
    done <<< "$Files"
  '';
}
