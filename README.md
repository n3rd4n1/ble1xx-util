ble1xx-util
===========

A set of Bash scripts to write firmware to Bluegiga's BLE1xx devices with the help of the [ccdbg](https://github.com/n3rd4n1/ccdbg) tool.

ble1xx_flash.sh
---------------

`./ble1xx_flash.sh <flash hex file> [license raw file]`

Requires the output hexadecimal file from `bgbuild.exe`, usually `out.hex`, as the first
argument. A license file, in raw format, can optionally be passed as the second argument.
Without the license file, the script will try to obtain the license data from the chip
so it can restore that data in case it is overwritten.

ble1xx_saveLicense.sh
---------------------

`./ble1xx_saveLicense.sh [destination file]`

This script will try to obtain the license data from the chip, save the data to file, and
print the name of the file to the standard output. If no destination file is specified,
data will be saved to a `mktemp`-generated file.

ble1xx_restoreLicense.sh
------------------------

`./ble1xx_restoreLicense.sh <license raw file>`

Requires the license file, in raw format, as its only argument. This script will try to
write the license data to the chip.

other scripts
-------------

The following scripts are used by the scripts above.

### licenseSize.sh

Prints the size of the license data.

### licenseAddress.sh

Prints the flash base address of the license data.

### ieeeAddress.sh

Prints the IEEE address of the chip.

### verifyLicense.sh

Verifies the license file if it is valid by comparing its IEEE address data to the chip's
IEEE address.

### whichCcdbg.sh

Prints the correct invocation of the `ccdbg` command i.e. `sudo ./ccdbg`. This should be
customized as required by the system.
