cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --json-1-to-python2-1
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --json-1-to-python2-1
cat $ROONDA_TMP_PATH/data.rd | $ROONDA_SELF_PATH --sexpr-1-to-python2-1
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --json-1-to-python2-1 --replace-tag ROONDA_STDIN_DATA --output-code $ROONDA_TMP_PATH/script.py
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --json-1-to-python2-1 --replace-tag ROONDA_STDIN_DATA $ROONDA_TMP_PATH/script.py

#################################################
# data.js:
#################################################
# [["abc", 10],
#  ["def", 30],
#  ["ghi", 100]]

#################################################
# data.rd:
#################################################
# ("abc" 10)
# ("def" 30)
# ("ghi" 100)

#################################################
# script.py:
#################################################
# print(ROONDA_STDIN_DATA)
