#/bin/sh

adb connect 192.168.42.5
adb wait-for-device
adb shell "mkdir -p /tmp/healthchecks/"
adb push units /tmp/healthchecks/
adb push busybox /tmp/healthchecks/
adb shell "set -e; for f in /tmp/healthchecks/units/*.sh; do echo \$f && sh \$f; done"
