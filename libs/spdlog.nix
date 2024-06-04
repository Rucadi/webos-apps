let
pkgs = import <nixpkgs> {};
common = pkgs.callPackage ../common {};
in
pkgs.stdenv.mkDerivation {
  name = "spdlog";
  version = "1.14.1";
  src = pkgs.fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v1.14.1";
    hash = "sha256-F7khXbMilbh5b+eKnzcB0fPPWQqUHqAYPWJb83OnUKQ=";
  };
  dontBuild = true;

  installPhase = (common.runChroot ''
    source ${common.toolchain}/environment-setup
    export PATH=$PATH:${pkgs.cmake}/bin
    cmake . -DCMAKE_INSTALL_PREFIX=$out -G Ninja
    ${pkgs.ninja}/bin/ninja install
  '');

}