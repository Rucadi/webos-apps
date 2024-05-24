let 
  pkgs = import <nixpkgs> {};
in 
(pkgs.callPackage ./common {}).toolchain