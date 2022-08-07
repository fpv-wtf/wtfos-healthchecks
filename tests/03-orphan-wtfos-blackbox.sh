#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )



set +e

if [ ! -d /blackbox/wtfos  ]; then
    mkdir /blackbox/wtfos
fi

rm /opt

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