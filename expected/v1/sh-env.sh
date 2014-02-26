#!/bin/sh

#################################################
# main.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/main.sh

cd $ROONDA_TMP_PATH

cat test.rd | $ROONDA_SELF_PATH --dry-run
(
    export ROONDA_TEST="Hello"
    cat test.rd | $ROONDA_SELF_PATH
)

END_OF_ROONDA_SOURCE_FILE
#################################################
# test.rd:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/test.rd
sh v1

(echo (ref ROONDA_TEST))

(assign T abc)
(echo (ref T))

(assign T echo)
((ref T) def)
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/main.sh
