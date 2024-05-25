{
  roms ? ./addons/pico8-roms, # Mario64 rom
  pkgs ? import <nixpkgs> {}
}:
let 
  ares-cli = pkgs.callPackage ./common/ares-cli.nix {};
  common = pkgs.callPackage ./common/default.nix {}; 
in
pkgs.stdenv.mkDerivation {
  name = "fake08";
  src = pkgs.fetchFromGitHub {
    owner = "rucadi";
    repo = "fake-08";
    rev = "2df06ef87b8c37df99d700fdf417c4f71cef27e8";
    sha256 = "sha256-kpO0iQj7eU5iMJwLweUiZ/ycoHGi9RbPEGjrZroPiIM=";
    fetchSubmodules = true;
  };

  dontConfigure = true;
  dontMake = true;
  buildInputs = [];
  nativeBuildInputs = [ ares-cli ];

  buildPhase =  common.runChroot ''
    source ${common.toolchain}/environment-setup
    # flags to include ${common.toolchain}/arm-webos-linux-gnueabi/sysroot/usr/include/boost/
    export CPATH="-I${common.toolchain}/arm-webos-linux-gnueabi/sysroot/usr/include/boost/"
    make webOS -j$(nproc)
  '';
  dontPatchELF = true;
  dontFixup = true;
  dontPatchShebangs = true;
  dontStrip = true;
  installPhase = ''
    mkdir -p $out
    mkdir tmp 
    export HOME=$(pwd)
    cp -R carts tmp/p8carts
    cp platform/webOS/FAKE08 tmp/FAKE08
    cp platform/webOS/appinfo.json tmp/
    cp platform/webOS/icon.jpg tmp/
    cp ${roms}/* tmp/*
    rm -f tmp/.gitkeep
    cd tmp 
    find .
    ares-package .
    cp -r * $out
  '';
}
