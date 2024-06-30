let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz") { }; # pin the channel to ensure reproducibility!
  # Add this if you are building a devShell in a flake. Usually, it's auto-detected
  # using lib.inNixShell, but that doesn't work in flakes
  # returnShellEnv = true;
in
pkgs.haskellPackages.developPackage {
  root = ./.;
}
