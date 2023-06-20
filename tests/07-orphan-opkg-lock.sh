#/bin/sh

set -e
set -x

UNITS="$( dirname -- "$0"; )/../units"
UNIT=$(basename -- "$0"; )

set +e

rm -f /opt/tmp
mkdir /opt/tmp
touch /opt/tmp/opkg.lock

sh $UNITS/$UNIT

if [ $? -ne 0  ]; then
    echo "$UNIT did not exit with code 0"
    exit 1
fi

if [ -f "/opt/tmp/opkg.lock" ]; then
    echo "test did not delete opkg.lock"
    exit 1
fi

rm -rf /opt/tmp
ln -s /tmp /opt/tmp

echo "test succsessful"