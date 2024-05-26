{
  marioworld ? ./smw.sfc, # Mario64 rom
  pkgs ? import <nixpkgs> {}
}:
let 
  ares-cli = pkgs.callPackage ./common/ares-cli.nix {};
  common = pkgs.callPackage ./common/default.nix {};

in
pkgs.stdenv.mkDerivation {
  name = "Super Mario World";

  src = pkgs.fetchFromGitHub {
    owner = "snesrev";
    repo = "smw";
    rev = "v0.1";
    sha256 = "sha256-n3qkxxwNAKZIiVKs8zIW02O7agbn0DR4P2xBa+Bqfk0=";
    fetchSubmodules = true;
  };

  dontConfigure = true;
  dontMake = true;
  buildInputs = [];
  nativeBuildInputs = [ pkgs.git ares-cli pkgs.hexdump pkgs.python3 pkgs.git pkgs.gcc pkgs.audiofile ];

  patchPhase = ''
    cp ${marioworld} ./smw.sfc
    patch -p1 < ${./patches/smworld/backdrop.patch}
  '';

  buildPhase =  common.runChroot ''
    source ${common.toolchain}/environment-setup
    make
  '';
  dontPatchELF = true;
  dontPatchShebangs = true;
  dontStrip = true;
  installPhase = 
  let 
    icon_jpg = pkgs.fetchurl {
      url = "https://cdn02.nintendo-europe.com/media/images/11_square_images/games_18/super_nintendo_4/SQ_SNES_SuperMarioWorld.jpg";
      sha256 = "sha256-TjzbGFYqyuJKLiziHVbEXv4mQMcY0mfo+xDLKlW80Ik=";
    };

    appinfo = 
    {
        id = "com.smworld.smw";
        version = "0.0.1";
        vendor =  "Super Mario world webos";
        type =  "native";
        main ="smw";
        title = "smworld";
        icon = "icon.jpg";
    };
  in 
  ''
    mkdir -p $out
    cp -R smw.ini  $out
    cp -R smw_assets.dat  $out
    cp -R smw  $out
    cp ${icon_jpg} $out/icon.jpg
    echo '${builtins.toJSON appinfo}' > $out/appinfo.json
    export HOME=$(pwd)
    cd $out
    ares-package . 
  '';
  dontFixup = true;
}


