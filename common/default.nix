{
  callPackage,
  system
}:
let 
  rootfs_meta = {
    aarch64-linux = {
      sha256 = "";
      imageDigest = "sha256:713d14111dd4f8c0d3d7fca20834002061b7146305aad7d079b60be780e47e00";
    };
    x86_64-linux = {
      sha256 = "sha256-jwU7BxoFbjYCUoG+qpqV4Nm0ba3Asi4HyRW6Y76KSHU=";
      imageDigest = "sha256:ba08ecc7ea9a9df8b009419fb65b5bb96e530582b67dcb12de13581a0feaea71";
    };
  };

  rootfs = callPackage ./exportDocker.nix {} ({
        imageName = "rucadi/webos-base-image";
    } // rootfs_meta."${system}");

  toolchain = (builtins.getFlake "github:rucadi/native-toolchain/patch-toolchain").defaultPackage."${system}";
in 
{
  inherit toolchain;
  runChroot = callPackage ./runChroot.nix {inherit rootfs;};
  inherit rootfs;
}