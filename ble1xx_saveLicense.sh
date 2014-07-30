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


# get license size
LICENSE_SIZE=`./licenseSize.sh`


# get license address
LICENSE_ADDRESS=`./licenseAddress.sh`
if [ $? -ne 0 ]; then exit -1; fi


# get IEEE address
IEEE_ADDRESS=`./ieeeAddress.sh`
if [ $? -ne 0 ]; then exit -1; fi


# create license file
TEMP_FILE=

if [ $# -gt 0 ]
then
   LICENSE_FILE=$1
   
   if ! [ -e $LICENSE_FILE ]
   then
      TEMP_FILE=$LICENSE_FILE
      touch $LICENSE_FILE
      if [ $? -ne 0 ]; then exit -1; fi
   fi
else
   TEMP_FILE=`mktemp /tmp/ble11x.XXXXXXXXXX`
   if [ $? -ne 0 ]; then exit -1; fi
   LICENSE_FILE=$TEMP_FILE
fi


# save license data (raw)
$CCDBG -rf $LICENSE_ADDRESS:$LICENSE_SIZE raw $LICENSE_FILE &> /dev/null

if [ $? -ne 0 ]
then
   rm -f $TEMP_FILE
   exit -1
fi


# verify IEEE address
IEEE_ADDRESS2=`hexdump -v -e '1/1 "%02x"' -s 35 -n 6  $LICENSE_FILE`

if [ $? -ne 0 ] || [ "$IEEE_ADDRESS" != "$IEEE_ADDRESS2" ]
then
   rm -f $TEMP_FILE
   exit -1
fi


# return name of license file
echo $LICENSE_FILE
exit 0
