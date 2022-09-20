#/bin/sh

#this script checks for the bind button being down and allows the user to ignore it for startup purposes
check () {
    #if system.img is not mounted
    if [ ! -f /data/wtfos_disable_bind ] && getevent -i -l | grep -q "KEY_PROG3\\*"; then
        echo "bind button in pressed state, cannot use for safe mode activation. make sure it is not pressed down, refresh the page to re-check. press 'fix' to ignore bind button at startup."
        return 2
    fi
}

fix () {
    touch /data/wtfos_disable_bind
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


