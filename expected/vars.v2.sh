#!/bin/sh

#################################################
# roonda_9c342f1f97d22c97a660f4606a04129a94b10a62.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_9c342f1f97d22c97a660f4606a04129a94b10a62.sh
echo -n 'sh
'
a='abc
'
echo -n "$a"
echo -n "$a"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_fdb75b7e951cef471b7283fe33fd65f5c6b06846.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_fdb75b7e951cef471b7283fe33fd65f5c6b06846.pl
use Encode qw/encode/;
use Data::Dumper;

print encode('utf-8', "perl\n");
my $a = "abc\n";
print encode('utf-8', $a);
print encode('utf-8', $a);
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_f4fc9416542fb0e1a0277bc9f09a0a942fa14402.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_f4fc9416542fb0e1a0277bc9f09a0a942fa14402.rb
print "ruby\n"
a = "abc\n"
print a
print a
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_3668916e8793542fd6ed39e3dddef0fee91907b0.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_3668916e8793542fd6ed39e3dddef0fee91907b0.py
import sys

sys.stdout.write(str("python\n"))
a = "abc\n"
sys.stdout.write(str(a))
sys.stdout.write(str(a))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_e25c0224770fa9d42fcbcfe8d3b4cd81b43eb1aa.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_e25c0224770fa9d42fcbcfe8d3b4cd81b43eb1aa.php
<?php

echo "php\n";
$a = "abc\n";
echo $a;
echo $a;
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_9c342f1f97d22c97a660f4606a04129a94b10a62.sh
perl $ROONDA_TMP_PATH/roonda_fdb75b7e951cef471b7283fe33fd65f5c6b06846.pl
ruby $ROONDA_TMP_PATH/roonda_f4fc9416542fb0e1a0277bc9f09a0a942fa14402.rb
python2 $ROONDA_TMP_PATH/roonda_3668916e8793542fd6ed39e3dddef0fee91907b0.py
python3 $ROONDA_TMP_PATH/roonda_3668916e8793542fd6ed39e3dddef0fee91907b0.py
php $ROONDA_TMP_PATH/roonda_e25c0224770fa9d42fcbcfe8d3b4cd81b43eb1aa.php
