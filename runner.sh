#/bin/sh

adb connect 192.168.42.5
adb wait-for-device
adb shell "mkdir -p /tmp/health"
adb push units /tmp/health/
adb push tests /tmp/health/
adb shell "sh /tmp/health/tests/$1*.sh"
