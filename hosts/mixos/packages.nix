{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    runapp
    hyprpolkitagent
    hyprshutdown

    # krita
    hyprpicker
    fuzzel

    rustc
    cargo
    gcc
    gnumake
    cmake

    inputs.mevim.packages.x86_64-linux.default
    inputs.meshell.packages.x86_64-linux.cli
    inputs.meshell.packages.x86_64-linux.quickshell
    inputs.metemplate.packages.x86_64-linux.default

    nasm
    llvmPackages_latest.bintools-unwrapped
    lazygit
    uv
    teams-for-linux
    libnotify
    obs-studio
    davinci-resolve
    mpv
    pkg-config
    anki

    wl-clipboard
    cursor-clip

    firefox

    tree

    kdePackages.dolphin
  ];
}
