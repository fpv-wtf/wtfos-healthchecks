#/bin/sh

#this script checks for an orphaned wtfos in slot 2 and cleans it up by reflashing slot 2

check () {
    #this only makes sense if we're booted to slot 1
    #the auto runner doesn't require it since eforcing slot 1 should happen prior
    #but we check to make sure in testing situations
    if [ $(unrd slot_1.status_active) == "1" ] && [ $(unrd slot_1.status_successful) == "1" ]; then
        mkdir -p /tmp/systwo
        mount -t ext4 /dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/system_2 /tmp/systwo
        if grep -q "#wtfos" /tmp/systwo/bin/*.sh; then 
            umount /tmp/systwo
            if [ -f /cache/ota.zip ] ; then
                echo "orphan wtfos is installed in slot 2, ota.zip available, can reflash"
                return 2
            else
                echo "orphan wtfos is installed in slot 2, ota zip not available, please contact support"
                return 1
            fi
        fi
        umount /tmp/systwo
        rm -r /tmp/systwo
    fi
}

fix () {
    if mount | grep -q '/proc/cmdline' -q; then
        echo "removing cmdline bindmount"
        umount /proc/cmdline
    fi
    echo "reflashing slot 2"
    echo "please wait, this will take a few minutes"
    update_engine --update_package=/cache/ota.zip
    unrd slot_2.status_active 0
    unrd slot_1.status_active 1
    echo "flashing slot 2 completed"
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
