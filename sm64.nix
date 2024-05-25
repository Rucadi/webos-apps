{
  mario64 ? ./baserom.us.z64, # Mario64 rom
  pkgs ? import <nixpkgs> {},
  patch_60fps ? true,
  patch_betterCamera ? false,
  patch_noDrawDistance ? false,
}:
let 
  ares-cli = pkgs.callPackage ./common/ares-cli.nix {};
  common = pkgs.callPackage ./common/default.nix {};

  BETTERCAMERA = if patch_betterCamera then "BETTERCAMERA=1" else "";
  NO_DRAW_DISTANCE = if patch_noDrawDistance then "NODRAWINGDISTANCE=1" else "";
in
pkgs.stdenv.mkDerivation {
  name = "mario64";
  src = pkgs.fetchFromGitHub {
    owner = "rucadi";
    repo = "sm64ex";
    rev = "a4129d7e7ded9e9acaf8e7f376450cb5e183bcf8";
    sha256 = "sha256-0hRsotRe4Y8SQRuzYXXHALKpx5zNM0IYGH6TQ9Pe8FQ=";
  };
  dontConfigure = true;
  dontMake = true;
  buildInputs = [];
  nativeBuildInputs = [ pkgs.git ares-cli pkgs.hexdump pkgs.python3 pkgs.git pkgs.gcc pkgs.audiofile ];

  patchPhase = ''
    cp ${mario64} ./baserom.us.z64
    ${if patch_60fps then "git apply enhancements/60fps_ex.patch" else ""}
    pushd tools
      make -j$(nproc)
    popd
  '';

  buildPhase =  common.runChroot ''
    source ${common.toolchain}/environment-setup
    TARGET_WEBOS=1 make -j$(nproc) ${NO_DRAW_DISTANCE} ${BETTERCAMERA} 
  '';
  dontPatchELF = true;
  dontPatchShebangs = true;
  dontStrip = true;
  installPhase = ''
    cd build/us_webos/webos
    HOME=$(pwd) ares-package .
    mkdir -p $out
    cp -R ./* $out
    echo   ${if patch_60fps then "60FPS" else ""} ${BETTERCAMERA} ${NO_DRAW_DISTANCE}  >  $out/compile_options
  '';
  dontFixup = true;
}
