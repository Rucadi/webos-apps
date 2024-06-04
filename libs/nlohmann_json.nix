let
pkgs = import <nixpkgs> {};
common = pkgs.callPackage ../common {};
in
pkgs.stdenv.mkDerivation {
  name = "nlohmann_json_webos";
  src = pkgs.fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };

  dontBuild = true;

  installPhase = (common.runChroot ''
    source ${common.toolchain}/environment-setup
    export PATH=$PATH:${pkgs.cmake}/bin
    cmake . -DCMAKE_INSTALL_PREFIX=$out -G Ninja
    ${pkgs.ninja}/bin/ninja install
  '');

}