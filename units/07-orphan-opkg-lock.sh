#/bin/sh

#this healthcheck deletes any orphan opkg.lock files present from old versions of wtfos

#this health check cheats and autofixes the problem without user confirmation

check () {
    #if it looks like we have an
    if [ -d "/opt/tmp" ] && [ ! -L "/opt/tmp" ] && \
       [ -f "/opt/tmp/opkg.lock" ] && ! ps | grep -q opkg; then
        fix
    fi
}

fix () {
    rm "/opt/tmp/opkg.lock"
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
