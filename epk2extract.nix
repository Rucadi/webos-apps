let 
  pkgs = import <nixpkgs> {};
in 
(pkgs.callPackage ./common {}).epk2extract