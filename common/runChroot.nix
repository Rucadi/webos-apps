{
    proot, 
    bashInteractiveFHS,
    writeScript,
    rootfs
}:
script:
let 
    modified_script = ''
        echo export out=$out > /tmp/out
        # Unset all environment variables
        unset $(env | cut -d= -f1)
        source /tmp/out
        export PATH="/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        env
        ${script}
    '';

in
''

    rm -rf /tmp/rootfs
    mkdir -p /tmp/rootfs
    mkdir $out
    tar xf ${rootfs} -C /tmp/rootfs

cat <<'EOF' > /tmp/rootfs/____script____.sh
    ${modified_script}
EOF
    chmod a+x /tmp/rootfs/____script____.sh

    ${proot}/bin/proot -r /tmp/rootfs \
     -b "${bashInteractiveFHS}/bin/bash:/usr/bin/sh" \
     -b "/proc:/proc" \
     -b "/nix:/nix" \
     -b "/dev:/dev" \
     -b "/build:/build" \
     -b "$out:$out" \
     -b "$(pwd):$(pwd)" \
     -w "$(pwd)" \
      /____script____.sh
''