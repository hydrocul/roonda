#!/bin/sh

cd `dirname $0`

./make.sh

rm -r actual 2>/dev/null
mkdir -p actual

echo ./testdata/basic-sh.rd
cat ./testdata/basic-sh.rd | ./target/roonda --output-code > ./actual/basic-sh.sh
diff -u expected/basic-sh.sh actual/basic-sh.sh && \
( sh actual/basic-sh.sh > actual/basic-sh.txt; diff -u expected/basic-sh.txt actual/basic-sh.txt )
cat ./testdata/basic-sh.rd | ./target/roonda  > ./actual/basic-sh-2.txt
diff -u expected/basic-sh-2.txt actual/basic-sh-2.txt

echo ./testdata/sh-env.rd
cat ./testdata/sh-env.rd | ./target/roonda --output-code > ./actual/sh-env.sh
diff -u expected/sh-env.sh actual/sh-env.sh
(
    export ROONDA_TEST="Hello"
    cat ./testdata/sh-env.rd | ./target/roonda > ./actual/sh-env.txt
    diff -u expected/sh-env.txt actual/sh-env.txt
)

echo ./testdata/basic-perl.rd
cat ./testdata/basic-perl.rd | ./target/roonda --output-code > ./actual/basic-perl.pl
diff -u expected/basic-perl.pl actual/basic-perl.pl
cat ./testdata/basic-perl.rd | ./target/roonda  > ./actual/basic-perl.txt
diff -u expected/basic-perl.txt actual/basic-perl.txt

echo ./testdata/sh-backticks.rd
cat ./testdata/sh-backticks.rd | ./target/roonda --output-code > ./actual/sh-backticks.sh
diff -u expected/sh-backticks.sh actual/sh-backticks.sh

echo ./testdata/order-of-operations.rd
cat ./testdata/order-of-operations.rd | ./target/roonda --output-code > ./actual/order-of-operations.pl
diff -u expected/order-of-operations.pl actual/order-of-operations.pl

echo ./testdata/sh-exec.rd
cat ./testdata/sh-exec.rd | ./target/roonda --output-code > ./actual/sh-exec.sh
diff -u expected/sh-exec.sh actual/sh-exec.sh


if diff -u -r expected actual >/dev/null; then
    echo "Success!"
else
    echo "Failed!"
    exit 1
fi

