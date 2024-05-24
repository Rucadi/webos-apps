let 
  pkgs = import <nixpkgs> {};
in 
(pkgs.callPackage ./common {}).rootfs