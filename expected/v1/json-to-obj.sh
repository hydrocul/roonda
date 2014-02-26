#!/bin/sh

#################################################
# data.js:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/data.js
[["abc", "Hey", 10],
 ["def", "Hello", 30],
 ["ghi", "Hello", 50],
 ["jk", "Hello   World!", 100]]
END_OF_ROONDA_SOURCE_FILE
#################################################

cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-perl-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-ruby-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python3-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-php-obj
