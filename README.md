# wtfos-healthchecks
Health check units for the configurator

# Units

## Check
A unit should be an executable (bash script) that gets called with 0 arguments to diagnose if it's issue is present. The units exit code should be:
 - 0 - if everything is okay
 - 1 - if there is a problem that cannot be fixed automatically
 - 2 - if there is a problem which can be fixed automatically

In case of exit code 1 or exit code 2 any output to stdout and stderr will be displayed to the user.

## Fix
In case of exit code 2 the user will be offered a button to automatically fix the issue. When the user presses the button the executable will be called again with exactly 1 argument with the value of "fix". The executable should then proceed to do it's best to fix the issue and end with an exit code of 0 or a reboot of the device. Any other exit code will be treated as a failure.

Any output to sdtout and sdterr will be displayed to the user.