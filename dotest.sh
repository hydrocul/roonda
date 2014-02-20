#!/bin/sh

cd `dirname $0`

(

./make.sh

rm -r actual 2>/dev/null
mkdir -p actual

RESULT=0

sh ./testdata/v1/test.sh || RESULT=1
sh ./testdata/v2/test.sh || RESULT=1

if [ $RESULT != 0 ]; then
    echo "Failed!"
    exit 1
elif diff -u -r expected actual >/dev/null; then
    echo "Success!"
else
    echo "Failed!"
    exit 1
fi

) 2>&1

