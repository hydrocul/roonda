#!/bin/sh

#################################################
# roonda_58d917154968e6bb2c7cf57933ff1f8a3ab37183.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_58d917154968e6bb2c7cf57933ff1f8a3ab37183.sh
echo sh
echo -n 123
echo -n '
'
echo abc
echo 'def
'
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_a21c8c525b371d0504d4c11bec84150a69e43ab2.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_a21c8c525b371d0504d4c11bec84150a69e43ab2.pl
use Encode qw/encode/;
use Data::Dumper;

print encode('utf-8', "perl" . "\n");
print encode('utf-8', 123);
print encode('utf-8', "\n");
print encode('utf-8', "abc" . "\n");
print Dumper("def\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_717b078fd14c465dd07cd51d7259e3870ed02c77.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_717b078fd14c465dd07cd51d7259e3870ed02c77.rb
puts "ruby"
print 123
print "\n"
puts "abc"
p "def\n"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_4c12e0e6b2758d47a3c2355d0bb68fb5019280b8.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_4c12e0e6b2758d47a3c2355d0bb68fb5019280b8.py
import sys

print(str("python2"))
sys.stdout.write(str(123))
sys.stdout.write(str("\n"))
print(str("abc"))
print("def\n")
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_f9375dae8afb70dc30187aa828ac96867c9bca7d.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_f9375dae8afb70dc30187aa828ac96867c9bca7d.py
import sys

print(str("python3"))
sys.stdout.write(str(123))
sys.stdout.write(str("\n"))
print(str("abc"))
print("def\n")
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_e906d352ab6f549651b51c2a2cbb907b96213a86.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_e906d352ab6f549651b51c2a2cbb907b96213a86.php
<?php

echo "php" . "\n";
echo 123;
echo "\n";
echo "abc" . "\n";
var_export("def\n");
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_58d917154968e6bb2c7cf57933ff1f8a3ab37183.sh
perl $ROONDA_TMP_PATH/roonda_a21c8c525b371d0504d4c11bec84150a69e43ab2.pl
ruby $ROONDA_TMP_PATH/roonda_717b078fd14c465dd07cd51d7259e3870ed02c77.rb
python2 $ROONDA_TMP_PATH/roonda_4c12e0e6b2758d47a3c2355d0bb68fb5019280b8.py
python3 $ROONDA_TMP_PATH/roonda_f9375dae8afb70dc30187aa828ac96867c9bca7d.py
php $ROONDA_TMP_PATH/roonda_e906d352ab6f549651b51c2a2cbb907b96213a86.php
