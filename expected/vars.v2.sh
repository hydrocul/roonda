#!/bin/sh

#################################################
# roonda_8de7a8b49dacabfdf84c657026a17fae45bdff33.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_8de7a8b49dacabfdf84c657026a17fae45bdff33.sh
a='abc
'
echo -n "$a"
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_1d71baf301d48172076743c426a406435c59ab8f.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_1d71baf301d48172076743c426a406435c59ab8f.pl
use Encode qw/encode/;

my $a = "abc\n";
print encode('utf-8', $a);
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_f07d001337ebefa089e66c5db11d088b393e1fc6.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_f07d001337ebefa089e66c5db11d088b393e1fc6.rb
a = "abc\n"
print a
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_e550860689966b8045d61b09484bb03c7c7d2407.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_e550860689966b8045d61b09484bb03c7c7d2407.py
import sys

a = "abc\n"
sys.stdout.write(str(a))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_abda7a0d4cbe13bf85842d5a54b0f525fdb04c96.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_abda7a0d4cbe13bf85842d5a54b0f525fdb04c96.php
<?php

$a = "abc\n";
echo $a;
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_8de7a8b49dacabfdf84c657026a17fae45bdff33.sh
perl $ROONDA_TMP_PATH/roonda_1d71baf301d48172076743c426a406435c59ab8f.pl
ruby $ROONDA_TMP_PATH/roonda_f07d001337ebefa089e66c5db11d088b393e1fc6.rb
python2 $ROONDA_TMP_PATH/roonda_e550860689966b8045d61b09484bb03c7c7d2407.py
python3 $ROONDA_TMP_PATH/roonda_e550860689966b8045d61b09484bb03c7c7d2407.py
php $ROONDA_TMP_PATH/roonda_abda7a0d4cbe13bf85842d5a54b0f525fdb04c96.php
