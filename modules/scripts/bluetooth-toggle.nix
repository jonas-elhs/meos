{pkgs, ...}:
pkgs.writeShellApplication {
  name = "bluetooth-toggle";
  runtimeInputs = with pkgs; [bluez];
  text = ''
    bluetoothctl power "$(bluetoothctl show | grep -q "Powered: yes" && echo off || echo on)" >/dev/null
    echo "Bluetooth $(bluetoothctl show | grep -q "Powered: yes" && echo on || echo off)"
  '';
}
