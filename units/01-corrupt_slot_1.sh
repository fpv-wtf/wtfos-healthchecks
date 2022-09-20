#/bin/sh

#this script enforces wtfos usage to slot 1 and will re-flash slot 1 before switching if it appears corrupt
check () {
    #check whatever our conditions is - this may be more complicated for other issues
    if [ $(unrd slot_1.status_successful) != "1" ] || [ $(unrd slot_1.status_bootable) != "1" ]; then
        echo "Slot 1 is corrupt, can reflash from Slot 2"
        return 2

    fi
}

fix () {
    echo "reflashing slot_1"
    echo "please wait, this will take a few minutes"
    if [ -f /cache/ota.zip ] ; then
        if mount | grep -q '/proc/cmdline' -q; then
            echo "removing cmdline bindmount"
            umount /proc/cmdline
        fi
        echo "reflashing from ota.zip"
        echo "please wait, this will take a few minutes"
        update_engine --update_package=/cache/ota.zip
    else
        echo "reflashing from slot 2"
        dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system_2 bs=1048675
        dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/vendor of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/vendor_2 bs=1048675
        dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/cp of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/cp_2 bs=1048675
        dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/normal of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/normal_2 bs=1048675
        dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/rf_nvram of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/rf_nvram_2 bs=1048675
        unrd slot_1.status_successful 1
        unrd slot_1.status_active 1
        unrd slot_1.status_bootable 1
        unrd slot_2.status_active 0
        unrd force_ota 0
    fi
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