#!/bin/sh

cd `dirname $0`

./make.sh

rm -r actual 2>/dev/null
mkdir -p actual

echo ./testdata/sexpr.rd
cat ./testdata/sexpr.rd | ./target/roonda --output-code > ./actual/sexpr.sh
diff -u expected/sexpr.sh actual/sexpr.sh
cat ./testdata/sexpr.rd | ./target/roonda  > ./actual/sexpr.txt
diff -u expected/sexpr.txt actual/sexpr.txt

echo ./testdata/from-json.js
cat ./testdata/from-json.js | ./target/roonda --from-json --output-code > ./actual/from-json.sh
diff -u expected/from-json.sh actual/from-json.sh
cat ./testdata/from-json.js | ./target/roonda --from-json > ./actual/from-json.txt
diff -u expected/from-json.txt actual/from-json.txt

echo ./testdata/json-to-obj.rd
cat ./testdata/json-to-obj.rd | ./target/roonda > ./actual/json-to-obj.txt
diff -u expected/json-to-obj.txt actual/json-to-obj.txt

echo ./testdata/sh-env.rd
cat ./testdata/sh-env.rd | ./target/roonda --output-code > ./actual/sh-env.sh
diff -u expected/sh-env.sh actual/sh-env.sh
(
    export ROONDA_TEST="Hello"
    cat ./testdata/sh-env.rd | ./target/roonda > ./actual/sh-env.txt
)
diff -u expected/sh-env.txt actual/sh-env.txt

echo ./testdata/roonda-tmp-path.rd
cat ./testdata/roonda-tmp-path.rd | ./target/roonda > ./actual/roonda-tmp-path.txt
diff -u expected/roonda-tmp-path.txt actual/roonda-tmp-path.txt

echo ./testdata/sh-pipe.rd
cat ./testdata/sh-pipe.rd | ./target/roonda --output-code > ./actual/sh-pipe.sh
diff -u expected/sh-pipe.sh actual/sh-pipe.sh
cat ./testdata/sh-pipe.rd | ./target/roonda > ./actual/sh-pipe.txt
diff -u expected/sh-pipe.txt actual/sh-pipe.txt

echo ./testdata/sh-embed-script.rd
cat ./testdata/sh-embed-script.rd | ./target/roonda --output-code > ./actual/sh-embed-script.sh
diff -u expected/sh-embed-script.sh actual/sh-embed-script.sh
cat ./testdata/sh-embed-script.rd | ./target/roonda > ./actual/sh-embed-script.txt
diff -u expected/sh-embed-script.txt actual/sh-embed-script.txt

echo ./testdata/sh-backticks.rd
cat ./testdata/sh-backticks.rd | ./target/roonda --output-code > ./actual/sh-backticks.sh
diff -u expected/sh-backticks.sh actual/sh-backticks.sh

echo ./testdata/sh-strcat.rd
cat ./testdata/sh-strcat.rd | ./target/roonda --output-code > ./actual/sh-strcat.sh
diff -u expected/sh-strcat.sh actual/sh-strcat.sh
(
    export ROONDA_TEST="Hello"
    cat ./testdata/sh-strcat.rd | ./target/roonda > ./actual/sh-strcat.txt
)
diff -u expected/sh-strcat.txt actual/sh-strcat.txt

echo ./testdata/sh-exec.rd
cat ./testdata/sh-exec.rd | ./target/roonda --output-code > ./actual/sh-exec.sh
diff -u expected/sh-exec.sh actual/sh-exec.sh

echo ./testdata/sh-call-roonda.rd
cat ./testdata/sh-call-roonda.rd | ./target/roonda --output-code > ./actual/sh-call-roonda.sh
diff -u expected/sh-call-roonda.sh actual/sh-call-roonda.sh
cat ./testdata/sh-call-roonda.rd | ./target/roonda > ./actual/sh-call-roonda.txt
diff -u expected/sh-call-roonda.txt actual/sh-call-roonda.txt

echo ./testdata/sh-call-langs.rd
cat ./testdata/sh-call-langs.rd | ./target/roonda --output-code > ./actual/sh-call-langs.sh
diff -u expected/sh-call-langs.sh actual/sh-call-langs.sh
cat ./testdata/sh-call-langs.rd | ./target/roonda > ./actual/sh-call-langs.txt
diff -u expected/sh-call-langs.txt actual/sh-call-langs.txt

echo ./testdata/basic.rd
cat ./testdata/basic.rd | ./target/roonda --output-code > ./actual/basic.sh
diff -u expected/basic.sh actual/basic.sh
cat ./testdata/basic.rd | ./target/roonda  > ./actual/basic.txt
diff -u expected/basic.txt actual/basic.txt

echo ./testdata/operators.rd
cat ./testdata/operators.rd | ./target/roonda --output-code > ./actual/operators.sh
diff -u expected/operators.sh actual/operators.sh
cat ./testdata/operators.rd | ./target/roonda > ./actual/operators.txt
diff -u expected/operators.txt actual/operators.txt


if diff -u -r expected actual >/dev/null; then
    echo "Success!"
else
    echo "Failed!"
    exit 1
fi

