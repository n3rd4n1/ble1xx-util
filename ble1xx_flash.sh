#!/bin/bash

#
# The MIT License (MIT)
#
# Copyright (c) 2014 Billy Millare
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# 30jul2014
#


CCDBG=`./whichCcdbg.sh`


if [ $# -lt 1 ]
then
   echo "usage: $0 <flash hex file> [license raw file]"
   exit
fi


LICENSE_FILE=
TEMP_FILE=


if [ $# -gt 1 ]
then
   LICENSE_FILE=$2
fi


# save license data
if [ "$LICENSE_FILE" == "" ]
then
   echo saving license data...
   TEMP_FILE=`./ble11x_saveLicense.sh`
   if [ $? -ne 0 ]; then echo FAILED; exit -1; fi
   LICENSE_FILE=$TEMP_FILE
fi


# write flash data
echo writing flash data from hex file, \"$1\"...
$CCDBG -wf hex $1 verify &> /dev/null
if [ $? -ne 0 ]; then echo FAILED; exit -1; fi


# restore license data
echo restoring license data from raw file, \"$LICENSE_FILE\"...
./ble11x_restoreLicense.sh $LICENSE_FILE &> /dev/null
FAILED=$?
if [ "$TEMP_FILE" != "" ]; then rm -f $TEMP_FILE; fi
if [ $FAILED -ne 0 ]; then echo FAILED; exit -1; fi
