#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )



set +e


if mount | grep "/dev/loop"; then 
    remount_system=true
    while  mount | grep "/dev/loop";
    do
        /system/bin/umount -d -l /system
        sleep 1
    done
    echo "wtfos: loopmount unmounted"
fi

sh $UNITS/$UNIT

if [ $? -ne 1  ]; then
    echo "$UNIT did not detect system mount missing"
    exit 1
fi

if [ "$remount_system" = "true" ] ; then
    #prepare our new image
    until  mount | grep -q "/dev/loop";
    do
        /system/xbin/busybox mount -t ext4 -o loop,rw /blackbox/wtfos/system.img /system
        sleep 1
    done
fi

echo "test succsessful"