#!/bin/sh
#
# check script. Assumes that pyang is on path and that
# all standard modules are on its internal module path.
# Also assumes that the script is run from the root of the yang master.
#
cwd=$(pwd)
ietf_dir="standard/ietf"
ieee_dir="standard/ieee"
itu_dir="standard/itu"

to_check="published/ITU-T_SG15"

# relax constraint for now
# add --ietf if you want to do strict IETF checking
ietf_dir_flag="$cwd/$ietf_dir/RFC/"

checkDir() {
    local dir="$itu_dir/$1"
    echo "\nChecking yang files in $dir"
    exit_status=""
    pyang_flags="--verbose --path $ietf_dir_flag --path $cwd/$ieee_dir/published --path $cwd/$itu_dir/published"
    cd $dir
    printf "\n"
    for f in *.yang; do
        printf "pyang $pyang_flags $f\n"
        errors=$(pyang $pyang_flags $f 2>&1 | grep "error:")
#        pyang $pyang_flags $f
        if [ ! -z "$errors" ]; then
            echo Errors in $f
            printf "\n  $errors \n"
            exit_status="failed!"
        fi
    done
    if [ ! -z "$exit_status" ]; then
        exit 1
    fi
    cd $cwd
}

echo Checking modules with pyang command:
for d in $to_check; do
    checkDir $d
done
