#!/bin/sh

#################################################
# main.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/main.sh

cd $ROONDA_TMP_PATH

cat source.json | $ROONDA_SELF_PATH --from-json --dry-run

cat source.json | $ROONDA_SELF_PATH --from-json

END_OF_ROONDA_SOURCE_FILE
#################################################
# source.json:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/source.json
["sh", "v1",
 ["echo", "Hello"],
 ["echo", "Hello", "World"],
 ["echo", "Hello   World!"]]
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/main.sh
