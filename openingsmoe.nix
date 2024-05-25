let
  pkgs = import <nixpkgs> {};
  ares-cli = pkgs.callPackage ./common/ares-cli.nix {};
in
pkgs.stdenv.mkDerivation 
{
  name = "ares-cli";
  src = pkgs.fetchFromGitHub {
    owner = "rucadi";
    repo = "OpeningsMoe-webos";
    rev = "7c7df02d1674a29c329b8cfe0c11c5f21e6d7fc9";
    hash = "sha256-zubPYPel83RJDaV0+dbord1+fyOQB1FoxCwtOQbVxDs=";
  };
  buildInputs = [ ares-cli ];
  installPhase = ''
    HOME=$(pwd) ares-package .
    mkdir -p $out
    cp *.ipk $out/
  '';
  dontPatchELF = true;
  dontFixup = true;

}
