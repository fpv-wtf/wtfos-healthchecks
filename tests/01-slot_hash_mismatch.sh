#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )

unrd

active="1"
alternate="2"

if readlink /dev/block/platform/soc/f0000000.ahb/f0400000.dwmmc0/mirror/system | grep -q "system_2"; then
    active="2"
    alternate="1"
fi

unrd slot_${alternate}.system_md5 deadbeef

set +e
sh $UNITS/$UNIT

if [ $? -ne 2  ]; then
    echo "$UNIT did could not detect hash mismatch"
    exit 1
fi

sh $UNITS/$UNIT fix

if [ $? -ne 0 ]; then
    echo "fix did not exit cleanly"
    exit $?
fi

set -e

if [ "$(unrd slot_1.system_md5)" != "$(unrd slot_2.system_md5)" ]; then
    echo "Hashes still mismatch"
    exit 1

fi

unrd

echo "test succsessful"