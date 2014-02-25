#!/bin/sh

#################################################
# roonda_ffeff3ca35dd050358ffa0d67398524a5dd9637f.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_ffeff3ca35dd050358ffa0d67398524a5dd9637f.pl
print 3 * 4 * (5 + -6 + (10 - 8));
print "\n";
print 100 % 7;
print "\n";
print 3 ** 5;
print "\n";
print "abc" . "def" . "\n";
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
# roonda_7f090a42bd7ee5ef57d09fec534c9c791aa0a6f3.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_7f090a42bd7ee5ef57d09fec534c9c791aa0a6f3.py
import sys

sys.stdout.write(str(3 * 4 * (5 + -6 + (10 - 8))))
sys.stdout.write(str("\n"))
sys.stdout.write(str(100 % 7))
sys.stdout.write(str("\n"))
sys.stdout.write(str(3 ** 5))
sys.stdout.write(str("\n"))
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

perl $ROONDA_TMP_PATH/roonda_ffeff3ca35dd050358ffa0d67398524a5dd9637f.pl
ruby $ROONDA_TMP_PATH/roonda_f1881de283fa53af2c8e8ba75ce51ffa1870cf36.rb
python2 $ROONDA_TMP_PATH/roonda_7f090a42bd7ee5ef57d09fec534c9c791aa0a6f3.py
python3 $ROONDA_TMP_PATH/roonda_7f090a42bd7ee5ef57d09fec534c9c791aa0a6f3.py
php $ROONDA_TMP_PATH/roonda_93f75d513dd89c0fe1f7850889e9e541c94bf3bc.php
