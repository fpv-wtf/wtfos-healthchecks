#/bin/sh

#this healthcheck restores busybox if it's lost

#this health check cheats and autofixes the problem without user confirmation
#if we don't they are liable to proceed to updating (which don't block on health checks)

check () {
    #if system.img is not mounted
    if [ -L /opt/bin/wget ] && [ ! -f /opt/bin/busybox ]; then
        fix
    fi
}

fix () {
    cp /tmp/healthchecks/busybox /opt/bin/busybox
    chmod u+x /opt/bin/busybox
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
