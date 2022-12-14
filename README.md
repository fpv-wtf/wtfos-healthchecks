# wtfos-healthchecks
Health check units for the wtfos configurator. These are automation scripts to check for and fix issues occurring outside of what is possible with package updates due to one reason or another.

_If the issue can be fixed by simply publishing an update on an existing package then a healtheck unit should be avoided._

# Units
Units will be executed in alpabhetical order after adb connection and any non-passing units should be displayed to the user in the header of the application regadless of which page they are on.

All checks _must_ be passed in order to install wtfos.

## Check
A unit should be a bash script that gets called with 0 arguments to diagnose if it's issue is present. The units exit code should be:
 - 0 - if everything is okay
 - 1 - if there is a problem that cannot be fixed automatically
 - 2 - if there is a problem which can be fixed automatically

In case of exit code 1 or exit code 2 any output to stdout and stderr will be displayed to the user.

## Fix
In case of exit code 2 the user will be offered a button to automatically fix the issue. When the user presses the button the script will be called again with exactly 1 argument with the value of "fix". The script should then proceed to do it's best to fix the issue and end with an exit code of 0 or a reboot of the device. Any other exit code will be treated as a failure.

Any output to sdtout and sdterr will be displayed to the user.

## Testing
Test cases for each unit are located under tests. Each test should set up the require envorionment, check that the issue is detected, fix the issue and check the results (if possible). Currently tests are to be run one at a time manually due to the long duration operations and reboots involved. Pay attention to the output, 02 for example will restart to slot 2 if not already in slot 2 for test purposes and then needs to re ran again, which results in a reboot back to slot 1. Meaning each time the test script is run slots will be switched.

For convenience, use `./runner.sh testnumber` to quickly run a test from the host.