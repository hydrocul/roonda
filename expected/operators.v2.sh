#!/bin/sh

#################################################
# roonda_65a6215d34f35a1874a54412af6aa86bc40c0b99.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_65a6215d34f35a1874a54412af6aa86bc40c0b99.pl
use Encode qw/encode/;
use Data::Dumper;

print encode('utf-8', 3 * 4 * (5 + -6 + (10 - 8)));
print encode('utf-8', "\n");
print encode('utf-8', 100 % 7);
print encode('utf-8', "\n");
print encode('utf-8', 3 ** 5);
print encode('utf-8', "\n");
print encode('utf-8', "abc" . "def" . "\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_f1881de283fa53af2c8e8ba75ce51ffa1870cf36.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_f1881de283fa53af2c8e8ba75ce51ffa1870cf36.rb
print 3 * 4 * (5 + -6 + (10 - 8))
print "\n"
print 100 % 7
print "\n"
print 3 ** 5
print "\n"
print "abc" + "def" + "\n"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_c0db182c37f757888705b1016f7c303ab29ffa9b.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_c0db182c37f757888705b1016f7c303ab29ffa9b.py
import sys

sys.stdout.write(str(3 * 4 * (5 + -6 + (10 - 8))))
sys.stdout.write(str("\n"))
sys.stdout.write(str(100 % 7))
sys.stdout.write(str("\n"))
sys.stdout.write(str(3 ** 5))
sys.stdout.write(str("\n"))
print(str(100 // (3 + 4)))
sys.stdout.write(str("abc" + "def" + "\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_93f75d513dd89c0fe1f7850889e9e541c94bf3bc.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_93f75d513dd89c0fe1f7850889e9e541c94bf3bc.php
<?php

echo 3 * 4 * (5 + -6 + (10 - 8));
echo "\n";
echo 100 % 7;
echo "\n";
echo pow(3, 5);
echo "\n";
echo "abc" . "def" . "\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

echo perl
perl $ROONDA_TMP_PATH/roonda_65a6215d34f35a1874a54412af6aa86bc40c0b99.pl
echo ruby
ruby $ROONDA_TMP_PATH/roonda_f1881de283fa53af2c8e8ba75ce51ffa1870cf36.rb
echo python2
python2 $ROONDA_TMP_PATH/roonda_c0db182c37f757888705b1016f7c303ab29ffa9b.py
echo python3
python3 $ROONDA_TMP_PATH/roonda_c0db182c37f757888705b1016f7c303ab29ffa9b.py
echo php
php $ROONDA_TMP_PATH/roonda_93f75d513dd89c0fe1f7850889e9e541c94bf3bc.php
