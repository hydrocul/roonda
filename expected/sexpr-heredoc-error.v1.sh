#!/bin/sh

#################################################
# test.roonda:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/test.roonda
sh v1

(cat attachedfile.txt)

<< attachedfile.txt

aaa

END_OF_ROONDA_SOURCE_FILE
#################################################

cat $ROONDA_TMP_PATH/test.roonda | $ROONDA_SELF_PATH --dry-run 2> /dev/null
if '[' "$?" '=' 0 ']'; then
    echo success
else
    echo 'roonda execution error'
fi
