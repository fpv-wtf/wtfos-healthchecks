#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )

unrd

unrd slot_1.status_active 0
unrd slot_2.status_active 1

set +e
sh $UNITS/$UNIT

if [ $? -ne 2  ]; then
    echo "$UNIT did could not detect wrong slot"
    exit 1
fi

#check for deleted unrd empty regression
unrd -d slot_1.status_active

sh $UNITS/$UNIT

if [ $? -ne 2  ]; then
    echo "$UNIT did could not detect wrong slot"
    exit 1
fi

sh $UNITS/$UNIT fix

#we expect a reboot
echo "fix did not reboot"
exit 1