{
  lib,
  cmake,
  openssl,
  stdenv,
  lzo,
  libz,
  bash,
  ncurses,
  fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "epk2extract";
  version = "3.0.6";
  src = fetchFromGitHub {
    owner = "openlgtv";
    repo = "epk2extract";
    rev = "6e4d0a6606b70a66ffdd1814b1fc47e8ddeb4a2e";
    hash = "sha256-bLsr5QHNAigisqbcoGFPAhD1B8iSDu0ZfF2vgVXqILU=";
  };
 
 configurePhase = "
  echo '
  #ifdef __STDC__
  #define OF(args) args
  #else
  #define OF(args) ()
  #endif
  ' >> /tmp/a 
  cat /tmp/a /build/source/src/minigzip.c > /build/source/src/minigzip.c.new
  mv /build/source/src/minigzip.c.new /build/source/src/minigzip.c
 ";

 buildPhase = ''
    cd /build/source
    chmod a+x ./build.sh
    export CMAKE_FLAGS=-DCMAKE_BUILD_TYPE=Test
    bash ./build.sh
'';

  installPhase = ''
    mkdir -p $out/bin
    cp -r build_linux/* $out/bin
    rm -rf $out/bin/obj
  '';

  nativeBuildInputs = [bash cmake openssl lzo libz ncurses];
}
