#/bin/sh
#this script enforces wtfos usage to slot 1 and will re-flash slot 1 before switching if it appears corrupt
check () {
    #check whatever our conditions is - this may be more complicated for other issues
    if [ "$(unrd slot_1.status_active)" == "1" ] && [ "$(unrd slot_1.status_successful)" == "1" ]; then
        ##and return 0 if all is well
        return 0
    else
        #all is not well and we can fix it
        #return 1 here instead if no automatic fix is available
        echo "Slot 2 active, wtfos should be installed in Slot 1"
        return 2
    fi
}

fix () {
    #switch slots and reboot
    echo "Switching slots"
    unrd slot_1.status_active 1
    unrd slot_2.status_active 0
    echo "Rebooting"
    reboot
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
