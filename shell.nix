{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/21.11") {}
}:

let
  meme = import ./. { };
in
pkgs.mkShellNoCC {
  inherit meme;
  nativeBuildInputs = with pkgs; [
    haskell-language-server
    ormolu
  ];

  shellHook = ''
    LOCALE_ARCHIVE="$(nix-build --no-out-link '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive"

    export LANG=en_GB.UTF-8
  '';
}
