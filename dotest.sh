#!/bin/sh

cd `dirname $0`

./make.sh

rm -r actual 2>/dev/null
mkdir -p actual

echo ./testdata/sexpr.rd
cat ./testdata/sexpr.rd | ./target/roonda --output-code > ./actual/sexpr.sh
diff -u expected/sexpr.sh actual/sexpr.sh
sh actual/sexpr.sh > actual/sexpr.txt 2>/dev/null
diff -u expected/sexpr.txt actual/sexpr.txt
cat ./testdata/sexpr.rd | ./target/roonda  > ./actual/sexpr.2.txt
diff -u expected/sexpr.2.txt actual/sexpr.2.txt

echo ./testdata/from-json.js
cat ./testdata/from-json.js | ./target/roonda --from-json --output-code > ./actual/from-json.sh
diff -u expected/from-json.sh actual/from-json.sh
sh actual/from-json.sh > actual/from-json.txt 2>/dev/null
diff -u expected/from-json.txt actual/from-json.txt
cat ./testdata/from-json.js | ./target/roonda --from-json > ./actual/from-json.2.txt
diff -u expected/from-json.2.txt actual/from-json.2.txt

echo ./testdata/to-perl-obj.js
cat ./testdata/to-perl-obj.js | ./target/roonda --from-json --to-perl-obj-1 > ./actual/to-perl-obj.pl
diff -u expected/to-perl-obj.pl actual/to-perl-obj.pl

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

echo ./testdata/sh-call-langs.rd
cat ./testdata/sh-call-langs.rd | ./target/roonda --output-code > ./actual/sh-call-langs.sh
diff -u expected/sh-call-langs.sh actual/sh-call-langs.sh
cat ./testdata/sh-call-langs.rd | ./target/roonda > ./actual/sh-call-langs.txt
diff -u expected/sh-call-langs.txt actual/sh-call-langs.txt

echo ./testdata/basic-perl.rd
cat ./testdata/basic-perl.rd | ./target/roonda --output-code > ./actual/basic-perl.pl
diff -u expected/basic-perl.pl actual/basic-perl.pl
cat ./testdata/basic-perl.rd | ./target/roonda  > ./actual/basic-perl.txt
diff -u expected/basic-perl.txt actual/basic-perl.txt

echo ./testdata/basic-ruby.rd
cat ./testdata/basic-ruby.rd | ./target/roonda --output-code > ./actual/basic-ruby.rb
diff -u expected/basic-ruby.rb actual/basic-ruby.rb
cat ./testdata/basic-ruby.rd | ./target/roonda  > ./actual/basic-ruby.txt
diff -u expected/basic-ruby.txt actual/basic-ruby.txt

echo ./testdata/basic-python.rd
cat ./testdata/basic-python.rd | ./target/roonda --output-code > ./actual/basic-python.py
diff -u expected/basic-python.py actual/basic-python.py
cat ./testdata/basic-python.rd | ./target/roonda  > ./actual/basic-python.txt
diff -u expected/basic-python.txt actual/basic-python.txt

echo ./testdata/operators-perl.rd
cat ./testdata/operators-perl.rd | ./target/roonda --output-code > ./actual/operators-perl.pl
diff -u expected/operators-perl.pl actual/operators-perl.pl
cat ./testdata/operators-perl.rd | ./target/roonda > ./actual/operators-perl.txt
diff -u expected/operators-perl.txt actual/operators-perl.txt

echo ./testdata/operators-ruby.rd
cat ./testdata/operators-ruby.rd | ./target/roonda --output-code > ./actual/operators-ruby.rb
diff -u expected/operators-ruby.rb actual/operators-ruby.rb
cat ./testdata/operators-ruby.rd | ./target/roonda > ./actual/operators-ruby.txt
diff -u expected/operators-ruby.txt actual/operators-ruby.txt

echo ./testdata/operators-python.rd
cat ./testdata/operators-python.rd | ./target/roonda --output-code > ./actual/operators-python.py
diff -u expected/operators-python.py actual/operators-python.py
cat ./testdata/operators-python.rd | ./target/roonda > ./actual/operators-python.txt
diff -u expected/operators-python.txt actual/operators-python.txt


if diff -u -r expected actual >/dev/null; then
    echo "Success!"
else
    echo "Failed!"
    exit 1
fi

