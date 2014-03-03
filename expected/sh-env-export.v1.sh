#!/bin/sh

#################################################
# main.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/main.sh

echo $TEST_ENV1
echo $TEST_ENV2

END_OF_ROONDA_SOURCE_FILE
#################################################

TEST_ENV1='Hello 1'
TEST_ENV2='Hello 2'
export TEST_ENV2
sh $ROONDA_TMP_PATH/main.sh
