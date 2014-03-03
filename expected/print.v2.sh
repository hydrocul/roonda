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
# roonda_21a2fe7c72368bdab68a9d98c46ea557dedc6584.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_21a2fe7c72368bdab68a9d98c46ea557dedc6584.pl
use Encode qw/encode/;

print encode('utf-8', "perl" . "\n");
print encode('utf-8', 123);
print encode('utf-8', "\n");
print encode('utf-8', "abc" . "\n");
print encode('utf-8', "def\n" . "\n");
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
# roonda_59c4aef93d2d52007e732759e22928fede95cbec.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_59c4aef93d2d52007e732759e22928fede95cbec.py
import sys

print(str("python2"))
sys.stdout.write(str(123))
sys.stdout.write(str("\n"))
print(str("abc"))
print(str("def\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_729b3d9cffcb8c875cc0782c037dada0e8963d8e.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_729b3d9cffcb8c875cc0782c037dada0e8963d8e.py
import sys

print(str("python3"))
sys.stdout.write(str(123))
sys.stdout.write(str("\n"))
print(str("abc"))
print(str("def\n"))
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
perl $ROONDA_TMP_PATH/roonda_21a2fe7c72368bdab68a9d98c46ea557dedc6584.pl
ruby $ROONDA_TMP_PATH/roonda_717b078fd14c465dd07cd51d7259e3870ed02c77.rb
python2 $ROONDA_TMP_PATH/roonda_59c4aef93d2d52007e732759e22928fede95cbec.py
python3 $ROONDA_TMP_PATH/roonda_729b3d9cffcb8c875cc0782c037dada0e8963d8e.py
php $ROONDA_TMP_PATH/roonda_e906d352ab6f549651b51c2a2cbb907b96213a86.php
