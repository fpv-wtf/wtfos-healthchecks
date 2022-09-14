check () {
    #check whatever our conditions is - this may be more complicated for other issues
    if [ $(unrd slot_1.status_successful) != "1" ] && [ -f /data/wtfos_slot_attempt ]; then
        echo "Slot 1 is corrupt, can reflash from Slot 2"
        return 2

    fi
}

fix () {
    echo "reflashing slot_1"
    echo "please wait, this will take a few minutes"
    rm /data/wtfos_slot_attempt
    dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system_2 bs=1048675
    unrd slot_1.status_successful 1
    unrd slot_1.status_active 1
    unrd slot_2.status_active 0
    echo "Slot 1 restored to good state"
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