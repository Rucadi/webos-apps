let 
  rootfs_meta = {
    aarch64-linux = {
      sha256 = "";
      imageDigest = "";
    };
    x86_64-linux = {
      sha256 = "sha256-aynNbTYrphn1F9ETulJREi23tO7Gx7y1PDcuQ3ibE/M=";
      imageDigest = "sha256:dd4fbe93d300f6ab20d75cdced7a4f2bd6b710860100e145b4db4d67c6e2601a";
    };
  }.${builtins.currentSystem};
in  (import <nixpkgs> {}).callPackage ./exportDocker.nix {} ({
        imageName = "rucadi/mm";
    } // rootfs_meta)