cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --json-1-to-python2-1
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --json-1-to-python2-1
cat $ROONDA_TMP_PATH/data.rd | $ROONDA_SELF_PATH --sexpr-1-to-python2-1

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
