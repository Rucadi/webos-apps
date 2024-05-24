{
    proot, 
    bashInteractiveFHS,
    writeScript,
    rootfs
}:
script:
let 
    modified_script = ''
        export out=$out
        export PATH="/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    ${script}
    '';
in
''
    mkdir -p /tmp/rootfs
    mkdir $out
    tar xf ${rootfs} -C /tmp/rootfs
    ls -lah /tmp/rootfs
    ${proot}/bin/proot -r /tmp/rootfs \
     -b "${bashInteractiveFHS}/bin/bash:/usr/bin/sh" \
     -b "/proc:/proc" \
     -b "/nix:/nix" \
     -b "/dev:/dev" \
     -b "/build:/build" \
     -b "$out:$out" \
     -w "$(pwd)" \
      ${writeScript "run.sh" modified_script}
''