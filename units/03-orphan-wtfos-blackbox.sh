#/bin/sh

#this script checks for an orphaned wtfos is /blackbox and cleans it up

check () {
    #if /opt doesn't exist but wtfos exists in blackbox
    if [ ! -d /opt ] && [ -d /blackbox/wtfos ]; then
        #check if there are signs of wtfos scripts in current startup scripts
        if grep -q "#wtfos" /system/bin/*.sh; then 
            echo "wtfos is installed in current slot but not working, aborting"
            return 1
        else 
            echo "orphan wtfos install from slot 2 in /blackbox found, cleanup required"
            return 2
        fi
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
