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

(echo (strcat "Hey." " " "uh... " (backticks echo aaa) " " (ref ROONDA_TEST)))
test.rd >>
