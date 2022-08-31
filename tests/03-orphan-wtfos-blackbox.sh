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

if grep -q "#wtfos" /system/bin/*start_dji_system.sh && ! grep -q "#these are leftovers" /system/bin/*start_dji_system.sh ; then
    while mount | grep '/system ext4 ro' -q > /dev/null;
    do 
        /system/bin/mount -o rw,remount /system
        sleep 1
    done

   sed -i '/#wtfos/,/#\/wtfos/d' /system/bin/*start_dji_system.sh
fi



if [ ! -d /blackbox/wtfos  ]; then
    mkdir /blackbox/wtfos
fi

sh $UNITS/$UNIT

if [ $? -ne 2  ]; then
    echo "$UNIT did not detect /blackbox/wtfos"
    exit 1
fi

sh $UNITS/$UNIT fix

if [ -d /blackbox/wtfos  ]; then
    echo "$UNIT did not delete /blackbox/wtfos"
    exit 1
fi


echo "test succsessful"
