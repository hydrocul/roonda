cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2
cat $ROONDA_TMP_PATH/data.rd | $ROONDA_SELF_PATH --v1 --sexpr-to-python2
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2 --replace-tag ROONDA_STDIN_DATA --output-code $ROONDA_TMP_PATH/script.py
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2 --replace-tag ROONDA_STDIN_DATA $ROONDA_TMP_PATH/script.py
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2 $ROONDA_TMP_PATH/script2.py
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2 $ROONDA_TMP_PATH/script2.py
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-python2 $ROONDA_TMP_PATH/roonda_9f408e8e0470f4ed1bd165e6e9aaf32855509991.py
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --from-json --to-sexpr-obj
cat $ROONDA_TMP_PATH/data.js | $ROONDA_SELF_PATH --v1 --json-to-sexpr

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

#################################################
# script2.py:
#################################################
# print(stdin_data)

#################################################
# roonda_9f408e8e0470f4ed1bd165e6e9aaf32855509991.py:
#################################################
# import sys
# 
# sys.stdout.write(str(stdin_data))
# sys.stdout.write(str("\n"))
