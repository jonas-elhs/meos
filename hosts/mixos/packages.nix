{
  pkgs,
  inputs,
  ...
}: {
  programs._1password-gui.enable = true;

  environment.systemPackages = with pkgs; [
    swift
    swiftpm
    # Replace with https://github.com/NixOS/nixpkgs/pull/548520
    (pkgs.appimageTools.wrapType2 {
      pname = "xtool";
      version = "latest";

      src = pkgs.fetchurl {
        url = "https://github.com/xtool-org/xtool/releases/latest/download/xtool-x86_64.AppImage";
        hash = "sha256-2/2dchbwd8hMFxtojEFzw3wjyna/f9GF0amuilPatZ8=";
      };
    })
    unzip
    usbmuxd
    libimobiledevice

    fd
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
    inputs.meshell.packages.x86_64-linux.default
    inputs.metemplate.packages.x86_64-linux.default

    nasm
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

    tree

    kdePackages.dolphin

    (python3.withPackages (python-pkgs: [
      python-pkgs.psutil
    ]))
  ];
}
