#/bin/sh

adb connect 192.168.42.5
adb wait-for-device
adb shell "mkdir -p /tmp/health"
adb push units /tmp/health/
adb shell "set -e; for f in /tmp/health/units/*.sh; do echo \$f && sh \$f; done"
