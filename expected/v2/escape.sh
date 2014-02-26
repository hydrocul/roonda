#!/bin/sh

#################################################
# roonda_819582da5a8c534adc329f20e5035051115b584e.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_819582da5a8c534adc329f20e5035051115b584e.sh
echo -n 'Hello, world!
'
echo -n 'Say "Hello, world!"
'
echo -n '\\
'
echo -n 'あ
'
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_4fd52c091067dee7fd561e69ca74a366826f018f.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_4fd52c091067dee7fd561e69ca74a366826f018f.pl
use Encode qw/encode/;

use utf8;

print encode('utf-8', "Hello, world!\n");
print encode('utf-8', "Say \"Hello, world!\"\n");
print encode('utf-8', "\\\n");
print encode('utf-8', "あ\n");
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
# roonda_4f3ee126e3f62324be4e097eacb22495c0bc5cba.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_4f3ee126e3f62324be4e097eacb22495c0bc5cba.php
<?php

echo "Hello, world!\n";
echo "Say \"Hello, world!\"\n";
echo "\\\n";
echo "あ\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_819582da5a8c534adc329f20e5035051115b584e.sh
perl $ROONDA_TMP_PATH/roonda_4fd52c091067dee7fd561e69ca74a366826f018f.pl
ruby $ROONDA_TMP_PATH/roonda_193ceab912aaa16096a9dc89d612c2806ca03311.rb
python2 $ROONDA_TMP_PATH/roonda_4e3145305bce8b7b2dd7658f89e856ea13d6eb56.py
python3 $ROONDA_TMP_PATH/roonda_4e3145305bce8b7b2dd7658f89e856ea13d6eb56.py
php $ROONDA_TMP_PATH/roonda_4f3ee126e3f62324be4e097eacb22495c0bc5cba.php
