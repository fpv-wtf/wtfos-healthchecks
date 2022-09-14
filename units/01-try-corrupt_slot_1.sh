#/bin/sh

#this script checks for a corrupt slot 1 and will reflash it if necessary and ota.zip is available
check () {
    #check whatever our conditions is - this may be more complicated for other issues
    if [ $(unrd slot_1.status_successful) != "1" ] && [ ! -f /data/wtfos_slot_attempt ]; then
            echo "Slot 2 active, wtfos should be installed in Slot 1"
            return 2 
    else
        if [ -f /data/wtfos_slot_attempt ] ; then
            rm /data/wtfos_slot_attempt
            return 0
        fi
    fi
}

fix () {
    touch /data/wtfos_slot_attempt 
    unrd slot_1.status_successful 1
    unrd slot_1.status_active 1
    unrd slot_2.status_active 0
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
