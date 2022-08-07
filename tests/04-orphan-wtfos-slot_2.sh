#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )

if [ $(unrd slot_1.status_active) != "1" ]; then
    unrd slot_1.status_active 1
    unrd slot_2.status_active 0
    reboot
fi


mkdir -p /tmp/systwotest
mount -t ext4 /dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/system_2 /tmp/systwotest

if grep -q "#wtfos" /tmp/systwotest/bin/*.sh; then 
    echo "no need to inject dummy #wtfos"
else
    echo "injecting dummy #wtfos"
    echo "#wtfos" >> /tmp/systwotest/bin/setup_usb_serial.sh
fi

umount /tmp/systwotest

set +e

sh $UNITS/$UNIT

if [ $? -ne 2  ]; then
    echo "$UNIT did not detect /blackbox/wtfos"
    exit 1
fi

sh $UNITS/$UNIT fix

mount -t ext4 /dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/by-name/system_2 /tmp/systwotest

if grep -q "#wtfos" /tmp/systwotest/bin/*.sh; then 
    umount /tmp/systwotest
    echo "slot 2 did not get reflashed"
    exit 1
fi

umount /tmp/systwotest
echo "test succsessful"