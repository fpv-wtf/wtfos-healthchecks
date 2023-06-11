#/bin/sh

#this script checks for a bad files list for the wtfos-system package
#if it includes busybox we get into trouble when updating
#and we can't fix this for existing installs with an update because of that

#this health check cheats and autofixes the problem without user confirmation
#if we don't they are liable to proceed to updating (which don't block on health checks)

check () {
    #if system.img is not mounted
    if [ -f /opt/lib/opkg/info/wtfos-system.list ] && grep -q "busybox" /opt/lib/opkg/info/wtfos-system.list; then
        fix
    fi
}

fix () {
    busybox sed -i '\/blackbox\/wtfos\/opt\/bin\/busybox/d' /opt/lib/opkg/info/wtfos-system.list
}

#run the check
check
result=$?
if [ $result -ne 0 ]; then
    #if the exit code wasn't zero
    if [[ "$1" == "fix" ]]; then
        #if the first arg is "fix" proceed to fix
        fix
        exit $?
    else 
        #otherwise exit with the check results
        exit $result
    fi
fi
