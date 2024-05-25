{
  mario64 ? ./baserom.us.z64, # Mario64 rom
  pkgs ? import <nixpkgs> {}
}:
let 
  ares-cli = pkgs.callPackage ./common/ares-cli.nix {};
  common = pkgs.callPackage ./common/default.nix {}; 
in
pkgs.stdenv.mkDerivation {
  name = "fake8";
  src = pkgs.fetchFromGitHub {
    owner = "rucadi";
    repo = "fake-08";
    rev = "572f5c9c051f8f208af230085dd5dfaa16222dd1";
    sha256 = "sha256-yMYoId6Xfk6SbX2Lzhf5zUl3sUY6Pk44HD0wul6FE74=";
    fetchSubmodules = true;
  };
  dontConfigure = true;
  dontMake = true;
  buildInputs = [];
  nativeBuildInputs = [ ares-cli ];

  buildPhase =  common.runChroot ''
    source ${common.toolchain}/environment-setup
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
    cp platform/webOS/FAKE08 tmp/FAKE08
    cp platform/webOS/appinfo.json tmp/
    cp platform/webOS/icon.png tmp/
    cd tmp 
    ares-package .
    cp *.ipk $out
  '';
  
  fixUpPhase = '''';
}
