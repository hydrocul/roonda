#!/bin/sh

cd `dirname $0`

(

./make.sh

rm -r actual 2>/dev/null
mkdir -p actual

RESULT=0

(
    echo "RESULT=0"
    echo
    ls ./testdata | perl -ne 'if(/^([^.]+)\.(v[0-9]+)\.rd$/){ if($2 eq "v2"){print "export ROONDA_EXPERIMENTAL=1\n"} else {print "export ROONDA_EXPERIMENTAL=\n"} print "echo ./testdata/$1.$2.rd\ncat ./testdata/$1.$2.rd | ./target/roonda --dry-run > ./actual/$1.$2.sh || RESULT=1\ndiff -u expected/$1.$2.sh actual/$1.$2.sh\ncat ./testdata/$1.$2.rd | ./target/roonda > ./actual/$1.$2.txt || RESULT=1\ndiff -u expected/$1.$2.txt actual/$1.$2.txt\n\n";}'
    echo "exit \$RESULT"
) | sh || RESULT=1

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

