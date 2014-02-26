#!/bin/sh

#################################################
# data.js:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/data.js
[["abc", 10],
 ["def", 30],
 ["ghi", 100]]
END_OF_ROONDA_SOURCE_FILE
#################################################
# data.rd:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/data.rd
("abc" 10)
("def" 30)
("ghi" 100)
END_OF_ROONDA_SOURCE_FILE
#################################################

cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2-obj
cat $ROONDA_TMP_PATH/data.rd | $ROONDA_SELF_PATH --v1 --sexpr-to-python2-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --from-json --to-sexpr-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-sexpr-obj
