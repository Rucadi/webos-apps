{
  mario64 ? ./baserom.us.z64, # Mario64 rom
  toolchain ? (builtins.getFlake  "github:rucadi/native-toolchain").defaultPackage."${builtins.currentSystem}",
  pkgs ? import <nixpkgs> {},
  patch_60fps ? true,
  patch_betterCamera ? true,
  patch_noDrawDistance ? false,
  
}:
let 
  ares-cli-drv = {
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "ares-cli";
  version = "3.0.6";
  src = fetchFromGitHub {
    owner = "webos-tools";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-HhS49jg6PrWzXEX5P+NgcznMZw4yJyI0EYoCZ8y6UeU=";
  };

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-fTEYQY0ZhwYKnc7+EsgnnGovYJ8w+norq7oLnVrWNZg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://webostv.developer.lge.com/develop/tools/cli-introduction";
    description = "A collection of commands used for creating, packaging, installing, and launching web apps for LG webOS TV.";
    longDescription = ''
      webOS CLI (Command Line Interface) provides a collection of commands used for creating, packaging, installing,
      and launching web apps in the command line environment. The CLI allows you to develop and test your app without using
      a specific IDE.
    '';
    mainProgram = "ares";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rucadi ];
    platforms = lib.platforms.all;
  };
};
  ares-cli = pkgs.callPackage ares-cli-drv {};
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
  nativeBuildInputs = [ pkgs.git ares-cli toolchain pkgs.hexdump pkgs.python3 pkgs.git pkgs.gcc pkgs.audiofile ] ++ toolchain.nativeBuildInputs;

  buildPhase = let 
    BETTERCAMERA = if patch_betterCamera then "BETTERCAMERA=true" else "";
    NO_DRAW_DISTANCE = if patch_noDrawDistance then "NODRAWINGDISTANCE=1" else "";

  in 
  ''
    cp ${mario64} ./baserom.us.z64
    ${if patch_60fps then "git apply enhancements/60fps_ex.patch" else ""}
    pushd tools
      make -j$(nproc)
    popd
    source ${toolchain}/environment-setup
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
  '';
  fixUpPhase = '''';
}
