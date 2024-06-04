{
  callPackage,
  system
}:
let 
  rootfs_meta = {
    aarch64-linux = {
      sha256 = "sha256-Pm+cLUDI4401yRFxtfck4+ggrKxBtNUcWVQGrCu6kE4=";
      imageDigest = "sha256:65b09f9b6a89bffc7dac58ac1445c5492fb6d421e7717896666d531cce405472";
    };
    x86_64-linux = {
      sha256 = "sha256-PQ5693Zv7XH3Znl8GVsv+qrPlRIciNatqtLYfqTrGUU=";
      imageDigest = "sha256:f8574688f03d9a2bf84662cdae4d09dd4c82bd7789ec000cd11df7243f9d8494";
    };
  };

  rootfs = callPackage ./exportDocker.nix {} ({
        imageName = "rucadi/webos-base-image";
    } // rootfs_meta."${system}");

  toolchain = (builtins.getFlake "github:rucadi/native-toolchain/3004032563c1a4e91431f7912123982ee6012bb7").defaultPackage."${system}";
in 
{
  inherit toolchain;
  runChroot = callPackage ./runChroot.nix {inherit rootfs;};
  epk2extract = callPackage ./epk2extract.nix {};
  inherit rootfs;
}