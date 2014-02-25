#!/bin/sh

#################################################
# roonda_d796d68e2464d27e191d38aa93159bcd7cce7d23.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_d796d68e2464d27e191d38aa93159bcd7cce7d23.sh
echo -n 'Hello, world!
'
echo -n 'Say "Hello, world!"
'
echo -n '\\
'
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_d796d68e2464d27e191d38aa93159bcd7cce7d23.sh
