sh v1

("sh" main.sh)

<< main.sh

cd $ROONDA_TMP_PATH

cat test.rd | $ROONDA_SELF_PATH --dry-run
(
    export ROONDA_TEST="Hello"
    cat test.rd | $ROONDA_SELF_PATH
)

main.sh >>

<< test.rd
sh v1

(echo (ref ROONDA_TEST))

(assign T abc)
(echo (ref T))

(assign T echo)
((ref T) def)
test.rd >>

