#!/bin/sh

#################################################
# roonda_16e4526e86ac3b9fb36516eb16be38ab1bad260f.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_16e4526e86ac3b9fb36516eb16be38ab1bad260f.sh
echo -n 'Hello, world!
'
echo -n 'Say "Hello, world!"
'
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_a4328cbc57ff7f97ab899e7e07903bd4dc04701c.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_a4328cbc57ff7f97ab899e7e07903bd4dc04701c.pl
print "Hello, world!\n";
print "Say \"Hello, world!\"\n";
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_12dc3dff281961296eace29a627ebf12f1a0b750.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_12dc3dff281961296eace29a627ebf12f1a0b750.rb
print "Hello, world!\n"
print "Say \"Hello, world!\"\n"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_7448a7bb27fb7a41f95676f3358b029255eaa73e.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_7448a7bb27fb7a41f95676f3358b029255eaa73e.py
import sys

sys.stdout.write(str("Hello, world!\n"))
sys.stdout.write(str("Say \"Hello, world!\"\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_0e79de2683533e3dbd39ecf76f45fea410271cdd.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_0e79de2683533e3dbd39ecf76f45fea410271cdd.php
<?php

echo "Hello, world!\n";
echo "Say \"Hello, world!\"\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_16e4526e86ac3b9fb36516eb16be38ab1bad260f.sh
perl $ROONDA_TMP_PATH/roonda_a4328cbc57ff7f97ab899e7e07903bd4dc04701c.pl
ruby $ROONDA_TMP_PATH/roonda_12dc3dff281961296eace29a627ebf12f1a0b750.rb
python2 $ROONDA_TMP_PATH/roonda_7448a7bb27fb7a41f95676f3358b029255eaa73e.py
python3 $ROONDA_TMP_PATH/roonda_7448a7bb27fb7a41f95676f3358b029255eaa73e.py
php $ROONDA_TMP_PATH/roonda_0e79de2683533e3dbd39ecf76f45fea410271cdd.php
