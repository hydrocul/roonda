#!/bin/sh

#################################################
# roonda_130abb4e26744d80723880d9fe3b161d961d3a65.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_130abb4e26744d80723880d9fe3b161d961d3a65.py
import sys

print(str(1.23e+47))
print(str(1.23e+47))
print(str(1.23e-43))
print(str(1.23e+47))
print(str(1.23e+47))
print(str(1.23e-43))
print(str(1.23e+47))
print(str(1.23e+47))
print(str(1.23e-43))
print(str(1.23e+44))
print(str(1.23e+44))
print(str(1.23e-46))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_a864fe7df868f9e3d2f620ae7ad2a34f8d3e5495.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_a864fe7df868f9e3d2f620ae7ad2a34f8d3e5495.pl
use Encode qw/encode/;
use Data::Dumper;

my $p = 3.1416;
print encode('utf-8', 2 * 2.5 * 3.5 . "\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_5ae108ff1f077513d45f368ab9bdd0cf865ebe24.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_5ae108ff1f077513d45f368ab9bdd0cf865ebe24.rb
p = 3.1416
puts 2 * 2.5 * 3.5
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_08b03852a51c2abe95872967f56035ece26c13c2.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_08b03852a51c2abe95872967f56035ece26c13c2.py
import sys

p = 3.1416
print(str(2 * 2.5 * 3.5))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_247cd9d52e475172d7e47c20d9134c921ed3174c.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_247cd9d52e475172d7e47c20d9134c921ed3174c.php
<?php

$p = 3.1416;
echo 2 * 2.5 * 3.5 . "\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

python2 $ROONDA_TMP_PATH/roonda_130abb4e26744d80723880d9fe3b161d961d3a65.py
echo perl
perl $ROONDA_TMP_PATH/roonda_a864fe7df868f9e3d2f620ae7ad2a34f8d3e5495.pl
echo ruby
ruby $ROONDA_TMP_PATH/roonda_5ae108ff1f077513d45f368ab9bdd0cf865ebe24.rb
echo python2
python2 $ROONDA_TMP_PATH/roonda_08b03852a51c2abe95872967f56035ece26c13c2.py
echo python3
python3 $ROONDA_TMP_PATH/roonda_08b03852a51c2abe95872967f56035ece26c13c2.py
echo php
php $ROONDA_TMP_PATH/roonda_247cd9d52e475172d7e47c20d9134c921ed3174c.php
