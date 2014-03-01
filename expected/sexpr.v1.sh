#!/bin/sh

#################################################
# attachedfile.txt:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/attachedfile.txt

Hello Hello

END_OF_ROONDA_SOURCE_FILE
#################################################
# attachedfile-2.txt:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/attachedfile-2.txt

Hello Hello 2

END_OF_ROONDA_SOURCE_FILE
#################################################

echo Hello
echo Hello World
echo 'Hello   World!'
cat $ROONDA_TMP_PATH/attachedfile.txt
cat $ROONDA_TMP_PATH/attachedfile-2.txt
