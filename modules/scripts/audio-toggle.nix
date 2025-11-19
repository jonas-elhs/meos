{pkgs, ...}:
pkgs.writeShellApplication {
  name = "audio-toggle";
  runtimeInputs = with pkgs; [wireplumber];
  text = ''
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    echo "Audio $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "[MUTED]" && echo "muted" || echo "unmuted")"
  '';
}
