cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2-obj
cat $ROONDA_TMP_PATH/data.rd | $ROONDA_SELF_PATH --v1 --sexpr-to-python2-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --from-json --to-sexpr-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-sexpr-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH $ROONDA_TMP_PATH/pipe.rd

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
# pipe.rd:
#################################################
# python2 v1
# (print (stdin_data json))
# (print "\n")
