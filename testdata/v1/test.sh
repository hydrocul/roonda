
VERSION=v1

mkdir -p actual/$VERSION

RESULT=0

echo ./testdata/$VERSION/sexpr.rd
cat ./testdata/$VERSION/sexpr.rd | ./target/roonda --dry-run > ./actual/$VERSION/sexpr.sh || RESULT=1
diff -u expected/$VERSION/sexpr.sh actual/$VERSION/sexpr.sh
cat ./testdata/$VERSION/sexpr.rd | ./target/roonda  > ./actual/$VERSION/sexpr.txt || RESULT=1
diff -u expected/$VERSION/sexpr.txt actual/$VERSION/sexpr.txt

echo ./testdata/$VERSION/from-json.rd
cat ./testdata/$VERSION/from-json.rd | ./target/roonda --dry-run > ./actual/$VERSION/from-json.sh || RESULT=1
diff -u expected/$VERSION/from-json.sh actual/$VERSION/from-json.sh
cat ./testdata/$VERSION/from-json.rd | ./target/roonda  > ./actual/$VERSION/from-json.txt || RESULT=1
diff -u expected/$VERSION/from-json.txt actual/$VERSION/from-json.txt

echo ./testdata/$VERSION/json-to-obj.rd
cat ./testdata/$VERSION/json-to-obj.rd | ./target/roonda --dry-run > ./actual/$VERSION/json-to-obj.sh || RESULT=1
diff -u expected/$VERSION/json-to-obj.sh actual/$VERSION/json-to-obj.sh
cat ./testdata/$VERSION/json-to-obj.rd | ./target/roonda > ./actual/$VERSION/json-to-obj.txt || RESULT=1
diff -u expected/$VERSION/json-to-obj.txt actual/$VERSION/json-to-obj.txt

echo ./testdata/$VERSION/sh-env.rd
cat ./testdata/$VERSION/sh-env.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-env.sh || RESULT=1
diff -u expected/$VERSION/sh-env.sh actual/$VERSION/sh-env.sh
cat ./testdata/$VERSION/sh-env.rd | ./target/roonda > ./actual/$VERSION/sh-env.txt || RESULT=1
diff -u expected/$VERSION/sh-env.txt actual/$VERSION/sh-env.txt

echo ./testdata/$VERSION/roonda-tmp-path.rd
cat ./testdata/$VERSION/roonda-tmp-path.rd | ./target/roonda --dry-run > ./actual/$VERSION/roonda-tmp-path.sh || RESULT=1
diff -u expected/$VERSION/roonda-tmp-path.sh actual/$VERSION/roonda-tmp-path.sh
cat ./testdata/$VERSION/roonda-tmp-path.rd | ./target/roonda > ./actual/$VERSION/roonda-tmp-path.txt || RESULT=1
diff -u expected/$VERSION/roonda-tmp-path.txt actual/$VERSION/roonda-tmp-path.txt

echo ./testdata/$VERSION/sh-pipe.rd
cat ./testdata/$VERSION/sh-pipe.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-pipe.sh || RESULT=1
diff -u expected/$VERSION/sh-pipe.sh actual/$VERSION/sh-pipe.sh
cat ./testdata/$VERSION/sh-pipe.rd | ./target/roonda > ./actual/$VERSION/sh-pipe.txt || RESULT=1
diff -u expected/$VERSION/sh-pipe.txt actual/$VERSION/sh-pipe.txt

echo ./testdata/$VERSION/sh-embed-script.rd
cat ./testdata/$VERSION/sh-embed-script.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-embed-script.sh || RESULT=1
diff -u expected/$VERSION/sh-embed-script.sh actual/$VERSION/sh-embed-script.sh
cat ./testdata/$VERSION/sh-embed-script.rd | ./target/roonda > ./actual/$VERSION/sh-embed-script.txt || RESULT=1
diff -u expected/$VERSION/sh-embed-script.txt actual/$VERSION/sh-embed-script.txt

echo ./testdata/$VERSION/sh-backticks.rd
cat ./testdata/$VERSION/sh-backticks.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-backticks.sh || RESULT=1
diff -u expected/$VERSION/sh-backticks.sh actual/$VERSION/sh-backticks.sh
cat ./testdata/$VERSION/sh-backticks.rd | ./target/roonda > ./actual/$VERSION/sh-backticks.txt || RESULT=1
diff -u expected/$VERSION/sh-backticks.txt actual/$VERSION/sh-backticks.txt

echo ./testdata/$VERSION/sh-strcat.rd
cat ./testdata/$VERSION/sh-strcat.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-strcat.sh || RESULT=1
diff -u expected/$VERSION/sh-strcat.sh actual/$VERSION/sh-strcat.sh
cat ./testdata/$VERSION/sh-strcat.rd | ./target/roonda > ./actual/$VERSION/sh-strcat.txt || RESULT=1
diff -u expected/$VERSION/sh-strcat.txt actual/$VERSION/sh-strcat.txt

echo ./testdata/$VERSION/sh-exec.rd
cat ./testdata/$VERSION/sh-exec.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-exec.sh || RESULT=1
diff -u expected/$VERSION/sh-exec.sh actual/$VERSION/sh-exec.sh
cat ./testdata/$VERSION/sh-exec.rd | ./target/roonda > ./actual/$VERSION/sh-exec.txt || RESULT=1
diff -u expected/$VERSION/sh-exec.txt actual/$VERSION/sh-exec.txt

echo ./testdata/$VERSION/sh-call-roonda.rd
cat ./testdata/$VERSION/sh-call-roonda.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-call-roonda.sh || RESULT=1
diff -u expected/$VERSION/sh-call-roonda.sh actual/$VERSION/sh-call-roonda.sh
cat ./testdata/$VERSION/sh-call-roonda.rd | ./target/roonda > ./actual/$VERSION/sh-call-roonda.txt || RESULT=1
diff -u expected/$VERSION/sh-call-roonda.txt actual/$VERSION/sh-call-roonda.txt

echo ./testdata/$VERSION/escape.rd
cat ./testdata/$VERSION/escape.rd | ./target/roonda --dry-run > ./actual/$VERSION/escape.sh || RESULT=1
diff -u expected/$VERSION/escape.sh actual/$VERSION/escape.sh
cat ./testdata/$VERSION/escape.rd | ./target/roonda  > ./actual/$VERSION/escape.txt || RESULT=1
diff -u expected/$VERSION/escape.txt actual/$VERSION/escape.txt

echo ./testdata/$VERSION/var-trimmed.rd
cat ./testdata/$VERSION/var-trimmed.rd | ./target/roonda --dry-run > ./actual/$VERSION/var-trimmed.sh || RESULT=1
diff -u expected/$VERSION/var-trimmed.sh actual/$VERSION/var-trimmed.sh
cat ./testdata/$VERSION/var-trimmed.rd | ./target/roonda  > ./actual/$VERSION/var-trimmed.txt || RESULT=1
diff -u expected/$VERSION/var-trimmed.txt actual/$VERSION/var-trimmed.txt

exit $RESULT

