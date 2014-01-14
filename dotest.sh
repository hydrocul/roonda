#!/bin/sh

cd `dirname $0`

./make.sh

rm -r actual 2>/dev/null
mkdir -p actual

echo ./testdata/basic-01.rd
cat ./testdata/basic-01.rd | ./target/roonda --output-code > ./actual/basic-01.sh
diff -u expected/basic-01.sh actual/basic-01.sh && \
( sh actual/basic-01.sh > actual/basic-01.txt; diff -u expected/basic-01.txt actual/basic-01.txt )
cat ./testdata/basic-01.rd | ./target/roonda  > ./actual/basic-01-2.txt
diff -u expected/basic-01-2.txt actual/basic-01-2.txt

echo ./testdata/sh-backticks.rd
cat ./testdata/sh-backticks.rd | ./target/roonda --output-code > ./actual/sh-backticks.sh
diff -u expected/sh-backticks.sh actual/sh-backticks.sh

if diff -u -r expected actual >/dev/null; then
    echo "Success!"
else
    echo "Failed!"
    exit 1
fi

