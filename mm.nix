{
  zeldaMM ? ./baserom.mm.us.rev1.n64
}:
let 
pkgs = import <nixpkgs> {};
stdenv = pkgs.stdenv;
fetchFromGitHub = pkgs.fetchFromGitHub;
common = pkgs.callPackage ./common/default.nix {};
in
 stdenv.mkDerivation
 {
    name = "rom2elf";
    src = fetchFromGitHub {
          owner = "zeldaret";
          repo = "mm";
          rev = "23beee0717364de43ca9a82957cc910cf818de90";
          hash = "sha256-ZhT8gaiglmSagw7htpnGEoPUesSaGAt+UYr9ujiDurE=";
          fetchSubmodules = true;
    };
    patches = [ ./patches/mm/jumpWithAddress.patch ]; 
    postPatch =  ''
      cp ${zeldaMM} baserom.mm.us.rev1.n64
    '';

    buildPhase = common.runChrootMM ''
      make init -j8
    '';
    dontPatchELF = true;
    installPhase = ''
      mkdir -p $out
      mv mm.us.rev1.rom_uncompressed.elf $out
      mv mm.us.rev1.rom_uncompressed.z64 $out
    '';
 }