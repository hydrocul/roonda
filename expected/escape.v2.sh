#!/bin/sh

#################################################
# roonda_0065f302692e4ac0e9d380a25a15e3c00a2392f5.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_0065f302692e4ac0e9d380a25a15e3c00a2392f5.sh
echo -n 'Hello, world!
'
echo -n 'Say "Hello, world!"
'
echo -n '\\
'
echo -n '\\nx
'
echo -n 'あ
'
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_14c00aaaf0cf3f081dc74dea2010323426a7a552.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_14c00aaaf0cf3f081dc74dea2010323426a7a552.pl
use Encode qw/encode/;
use Data::Dumper;

use utf8;

print encode('utf-8', "Hello, world!\n");
print encode('utf-8', "Say \"Hello, world!\"\n");
print encode('utf-8', "\\\n");
print encode('utf-8', "\\nx\n");
print encode('utf-8', "あ\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_253be06d55bcb6b2692b6701b5402352240a060b.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_253be06d55bcb6b2692b6701b5402352240a060b.rb
print "Hello, world!\n"
print "Say \"Hello, world!\"\n"
print "\\\n"
print "\\nx\n"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_6201562efd1b508d1d6ea7af5deeea139b050021.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_6201562efd1b508d1d6ea7af5deeea139b050021.py
import sys

sys.stdout.write(str("Hello, world!\n"))
sys.stdout.write(str("Say \"Hello, world!\"\n"))
sys.stdout.write(str("\\\n"))
sys.stdout.write(str("\\nx\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_a9e5fa2e4e247e3177de8c88ca517f6b6fea7f6d.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_a9e5fa2e4e247e3177de8c88ca517f6b6fea7f6d.php
<?php

echo "Hello, world!\n";
echo "Say \"Hello, world!\"\n";
echo "\\\n";
echo "\\nx\n";
echo "あ\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_0065f302692e4ac0e9d380a25a15e3c00a2392f5.sh
perl $ROONDA_TMP_PATH/roonda_14c00aaaf0cf3f081dc74dea2010323426a7a552.pl
ruby $ROONDA_TMP_PATH/roonda_253be06d55bcb6b2692b6701b5402352240a060b.rb
python2 $ROONDA_TMP_PATH/roonda_6201562efd1b508d1d6ea7af5deeea139b050021.py
python3 $ROONDA_TMP_PATH/roonda_6201562efd1b508d1d6ea7af5deeea139b050021.py
php $ROONDA_TMP_PATH/roonda_a9e5fa2e4e247e3177de8c88ca517f6b6fea7f6d.php
