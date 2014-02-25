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
# roonda_b49d7391a86738e98ef8eabee168b4e36aa473f2.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_b49d7391a86738e98ef8eabee168b4e36aa473f2.pl
print "Hello, world!\n";
print "Say \"Hello, world!\"\n";
print "\\\n";
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_193ceab912aaa16096a9dc89d612c2806ca03311.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_193ceab912aaa16096a9dc89d612c2806ca03311.rb
print "Hello, world!\n"
print "Say \"Hello, world!\"\n"
print "\\\n"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_4e3145305bce8b7b2dd7658f89e856ea13d6eb56.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_4e3145305bce8b7b2dd7658f89e856ea13d6eb56.py
import sys

sys.stdout.write(str("Hello, world!\n"))
sys.stdout.write(str("Say \"Hello, world!\"\n"))
sys.stdout.write(str("\\\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_8b751477b3c9ea5bcc4d3c41e10eb0072a94a598.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_8b751477b3c9ea5bcc4d3c41e10eb0072a94a598.php
<?php

echo "Hello, world!\n";
echo "Say \"Hello, world!\"\n";
echo "\\\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_d796d68e2464d27e191d38aa93159bcd7cce7d23.sh
perl $ROONDA_TMP_PATH/roonda_b49d7391a86738e98ef8eabee168b4e36aa473f2.pl
ruby $ROONDA_TMP_PATH/roonda_193ceab912aaa16096a9dc89d612c2806ca03311.rb
python2 $ROONDA_TMP_PATH/roonda_4e3145305bce8b7b2dd7658f89e856ea13d6eb56.py
python3 $ROONDA_TMP_PATH/roonda_4e3145305bce8b7b2dd7658f89e856ea13d6eb56.py
php $ROONDA_TMP_PATH/roonda_8b751477b3c9ea5bcc4d3c41e10eb0072a94a598.php
