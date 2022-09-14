#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )

unrd

if [ $(unrd slot_2.status_active) != "1" ]; then
    unrd slot_1.status_active 0
    unrd slot_2.status_active 1
    reboot
fi

if [ $(unrd slot_1.status_successful) != "1" ]; then
    echo "slot already corrupt? aborting test"
    exit 1
fi

unrd slot_1.status_successful 0
touch /data/wtfos_slot_attempt

set +e
sh $UNITS/$UNIT

if [ $? -ne 2  ]; then
    echo "$UNIT did could not detect slot corruption"
    exit 1
fi

sh $UNITS/$UNIT fix

if [ $? -ne 0 ]; then
    echo "fix did not exit cleanly"
    exit $?
fi

set -e

if [ $(unrd slot_1.status_active) != "1" ]; then
    echo "slot 2 is still active, aborting"
    exit 1
fi

unrd

echo "test succsessful"