#/bin/sh

#this script enforces wtfos usage to slot 1 and will re-flash slot 1 before switching if it appears corrupt
check () {
    #check whatever our conditions is - this may be more complicated for other issues
    if [ "$(unrd slot_1.system_md5)" != "$(unrd slot_2.system_md5)" ]; then
        echo "Firmware slot version mismatch, can reflash"
        return 2
    fi
}

fix () {
    active="1"
    alternate="2"

    if readlink /dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system | grep -q "system_2"; then
        active="2"
        alternate="1"
    fi

    echo "Reflashing alternate slot from active slot"
    echo "Please wait, this will take a few minutes"
    dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system_2 bs=1048675
    dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/vendor of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/vendor_2 bs=1048675
    dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/cp of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/cp_2 bs=1048675
    dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/normal of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/normal_2 bs=1048675
    dd if=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/rf_nvram of=/dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/rf_nvram_2 bs=1048675
    unrd slot_${alternate}.status_successful 1
    unrd slot_${alternate}.status_bootable 1
    unrd slot_${alternate}.system_md5 $(unrd slot_${active}.system_md5)

    echo "Alternate slot restored to good state"
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