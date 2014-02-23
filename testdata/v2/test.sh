
VERSION=v2
export ROONDA_EXPERIMENTAL=1

mkdir -p actual/$VERSION

RESULT=0

echo ./testdata/$VERSION/sexpr.rd
cat ./testdata/$VERSION/sexpr.rd | ./target/roonda --dry-run > ./actual/$VERSION/sexpr.sh || RESULT=1
diff -u expected/$VERSION/sexpr.sh actual/$VERSION/sexpr.sh
cat ./testdata/$VERSION/sexpr.rd | ./target/roonda  > ./actual/$VERSION/sexpr.txt || RESULT=1
diff -u expected/$VERSION/sexpr.txt actual/$VERSION/sexpr.txt

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

echo ./testdata/$VERSION/sh-call-langs.rd
cat ./testdata/$VERSION/sh-call-langs.rd | ./target/roonda --dry-run > ./actual/$VERSION/sh-call-langs.sh || RESULT=1
diff -u expected/$VERSION/sh-call-langs.sh actual/$VERSION/sh-call-langs.sh
cat ./testdata/$VERSION/sh-call-langs.rd | ./target/roonda > ./actual/$VERSION/sh-call-langs.txt || RESULT=1
diff -u expected/$VERSION/sh-call-langs.txt actual/$VERSION/sh-call-langs.txt

echo ./testdata/$VERSION/basic.rd
cat ./testdata/$VERSION/basic.rd | ./target/roonda --dry-run > ./actual/$VERSION/basic.sh || RESULT=1
diff -u expected/$VERSION/basic.sh actual/$VERSION/basic.sh
cat ./testdata/$VERSION/basic.rd | ./target/roonda  > ./actual/$VERSION/basic.txt || RESULT=1
diff -u expected/$VERSION/basic.txt actual/$VERSION/basic.txt

echo ./testdata/$VERSION/operators.rd
cat ./testdata/$VERSION/operators.rd | ./target/roonda --dry-run > ./actual/$VERSION/operators.sh || RESULT=1
diff -u expected/$VERSION/operators.sh actual/$VERSION/operators.sh
cat ./testdata/$VERSION/operators.rd | ./target/roonda > ./actual/$VERSION/operators.txt || RESULT=1
diff -u expected/$VERSION/operators.txt actual/$VERSION/operators.txt

echo ./testdata/$VERSION/statements.rd
cat ./testdata/$VERSION/statements.rd | ./target/roonda --dry-run > ./actual/$VERSION/statements.sh || RESULT=1
diff -u expected/$VERSION/statements.sh actual/$VERSION/statements.sh
cat ./testdata/$VERSION/statements.rd | ./target/roonda  > ./actual/$VERSION/statements.txt || RESULT=1
diff -u expected/$VERSION/statements.txt actual/$VERSION/statements.txt

echo ./testdata/$VERSION/vars.rd
cat ./testdata/$VERSION/vars.rd | ./target/roonda --dry-run > ./actual/$VERSION/vars.sh || RESULT=1
diff -u expected/$VERSION/vars.sh actual/$VERSION/vars.sh
cat ./testdata/$VERSION/vars.rd | ./target/roonda  > ./actual/$VERSION/vars.txt || RESULT=1
diff -u expected/$VERSION/vars.txt actual/$VERSION/vars.txt

exit $RESULT

