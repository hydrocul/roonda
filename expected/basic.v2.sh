#!/bin/sh

#################################################
# roonda_1350897e53a3e64060c977ce2a724e19d937e0f6.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_1350897e53a3e64060c977ce2a724e19d937e0f6.sh
echo 'Hello, world!'
echo -n `expr 1 '+' 2`
echo -n '
'
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_cd7ce4ddf9a473bbc0b3da0687a2a1f7897a0905.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_cd7ce4ddf9a473bbc0b3da0687a2a1f7897a0905.pl
use Encode qw/encode/;
use Data::Dumper;

print("Hello, world!\n");
print encode('utf-8', 1 + 2);
print encode('utf-8', "\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_1f4bc1c636ef5be569ef1edaf9d224bdf5901c42.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_1f4bc1c636ef5be569ef1edaf9d224bdf5901c42.rb
print("Hello, world!\n")
print 1 + 2
print "\n"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_297ebd45cf2756ecad4107087f0dbeeeb734dba8.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_297ebd45cf2756ecad4107087f0dbeeeb734dba8.py
import sys

print("Hello, world!")
sys.stdout.write(str(1 + 2))
sys.stdout.write(str("\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_34ef7f4f9ba767657ce580bf3a2d9038ba84ea95.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_34ef7f4f9ba767657ce580bf3a2d9038ba84ea95.php
<?php

echo("Hello, world!\n");
echo 1 + 2;
echo "\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_1350897e53a3e64060c977ce2a724e19d937e0f6.sh
perl $ROONDA_TMP_PATH/roonda_cd7ce4ddf9a473bbc0b3da0687a2a1f7897a0905.pl
ruby $ROONDA_TMP_PATH/roonda_1f4bc1c636ef5be569ef1edaf9d224bdf5901c42.rb
python2 $ROONDA_TMP_PATH/roonda_297ebd45cf2756ecad4107087f0dbeeeb734dba8.py
python3 $ROONDA_TMP_PATH/roonda_297ebd45cf2756ecad4107087f0dbeeeb734dba8.py
php $ROONDA_TMP_PATH/roonda_34ef7f4f9ba767657ce580bf3a2d9038ba84ea95.php
