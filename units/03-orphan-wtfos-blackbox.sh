#/bin/sh

#this script checks for an orphaned wtfos is /blackbox and cleans it up

check () {
    #if /blackbox/wtfos exists
    if [ -d /blackbox/wtfos ]; then
        if grep -q "#wtfos" /system/bin/*start_dji_system.sh && ! grep -q "#these are leftovers" /system/bin/*start_dji_system.sh ; then
            #wtfos is installed in this slot, all good (for this unit)
            return 0
        elif mount | grep "/dev/loop"; then
            #wtfos is running, so can't be orphan
            return 0
        fi

        #check if there are signs of wtfos scripts in current startup scripts
        echo "orphan wtfos install from slot 2 in /blackbox found, cleanup required"
        return 2
    fi
}

fix () {
    echo "cleaning up /blackbox/wtfos"
    rm -rf /blackbox/wtfos
    rm -rf /blackbox/wtfos.log
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
