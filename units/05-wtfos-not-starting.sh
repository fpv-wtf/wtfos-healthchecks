#/bin/sh

#this script checks for an orphaned wtfos is /blackbox and cleans it up
set -x
set -e
check () {
    #if system.img is not mounted
    if ! mount | grep "/dev/loop" ; then
        ##and wtfos is found in startup script and it's not leftovers
        if grep -q "#wtfos" /system/bin/*start_dji_system.sh && ! grep -q "#these are leftovers" /system/bin/*start_dji_system.sh ; then
            echo "wtfos is installed but system.img is not mounted, please try re-installing wtfos"
            return 1
        fi
    fi
}

fix () {
    echo "no fix available"
    return 1
}

#run the check
check
result=$?
if [ $result -ne 0 ]; then
    #if the exit code wasn't zero
    if [[ "$1" == "fix" ]]; then
        #if the first arg is "fix" proceed to fix
        fix
        exit $?
    else 
        #otherwise exit with the check results
        exit $result
    fi
fi
