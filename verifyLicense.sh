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


if [ $# -ne 1 ]; then
   echo "usage: $0 <license raw file>"
   exit
fi


# license file (raw)
LICENSE_FILE=$1


# get license size
LICENSE_SIZE=`./licenseSize.sh`


# verify license size
LICENSE_SIZE2=`wc -c $LICENSE_FILE 2> /dev/null | sed 's/.*\(.[0-9]\).*/\1/'`
if [ "$LICENSE_SIZE2" == "" ] || [ $LICENSE_SIZE2 -lt $LICENSE_SIZE ]; then exit -1; fi


# get IEEE address
IEEE_ADDRESS=`./ieeeAddress.sh`
if [ $? -ne 0 ]; then exit -1; fi


# verify IEEE address
IEEE_ADDRESS2=`hexdump -v -e '1/1 "%02x"' -s 35 -n 6 $LICENSE_FILE 2> /dev/null`
if [ $? -ne 0 ] || [ "$IEEE_ADDRESS" != "$IEEE_ADDRESS2" ]; then exit -1; fi


# success!
exit 0
