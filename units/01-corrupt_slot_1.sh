#/bin/sh

#this script checks for a corrupt slot 1 and will reflash it if necessary and ota.zip is available 
check () {
    #check whatever our conditions is - this may be more complicated for other issues
    if [ $(unrd slot_1.status_successful) != "1" ]; then
        if [ -f /cache/ota.zip ] ; then
            echo "Slot 1 is corrupt, ota.zip available, can reflash"
            return 2
        else
            echo "Slot 1 is currupt and ota.zip is not available, please contact support"
            return 1
        fi
    fi
}

fix () {
    if mount | grep -q '/proc/cmdline' -q; then
        echo "removing cmdline bindmount"
        umount /proc/cmdline
    fi
    echo "reflashing slot_1"
    echo "please wait, this will take a few minutes"
    update_engine --update_package=/cache/ota.zip
    echo "Slot 1 restored to factory state"

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
