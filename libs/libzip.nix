let
pkgs = import <nixpkgs> {};
common = pkgs.callPackage ../common {};
in
pkgs.stdenv.mkDerivation {
  name = "libzip_webos";
  version = "1.10.1";
  src = pkgs.fetchurl {
    url = "https://libzip.org/download/libzip-1.10.1.tar.gz";
    sha256 = "sha256-lmmuXf46xbOJdTbchGaodMjPLA47H90I11snOIQpk2M=";
  };
  dontBuild = true;

  installPhase = (common.runChroot ''
    source ${common.toolchain}/environment-setup
    export PATH=$PATH:${pkgs.cmake}/bin
    cmake . -DCMAKE_INSTALL_PREFIX=$out -G Ninja
    ${pkgs.ninja}/bin/ninja install
  '');

}