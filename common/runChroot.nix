{
    proot, 
    bashInteractiveFHS,
    writeScript,
    rootfs
}:
script:
let 
    modified_script = let 
        dollar = "$";
    in ''
        envars=()
        envars+=("SHELL")
        envars+=("out")

        if [ $# != 1 ]; then
            for ((i=1; i<=$#; i++)); do
                envars+=("$1")
                shift
            done
        fi


        # Save the current environment variables
        saved_envars=()
        for envar in "${dollar}{envars[@]}"; do
            if [ -z "${dollar}{!envar}" ]; then
                echo "Error: Environment variable $envar is not set"
                exit 1
            fi
            saved_envars+=("$envar=${dollar}{!envar}")
        done

        # Unset all environment variables
        unset $(env | cut -d= -f1)

        # Set the saved environment variables
        for saved_envar in "${dollar}{saved_envars[@]}"; do
            export "$saved_envar"
        done
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