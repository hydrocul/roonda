#!/bin/sh

#################################################
# roonda_f7e85e5c5ce2e038726432f2bd465e2b096d92d8.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_f7e85e5c5ce2e038726432f2bd465e2b096d92d8.pl
use Encode qw/encode/;
use Data::Dumper;

my $a = 1;
$a += 2 * 3;
print encode('utf-8', $a . "\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_5873db221d9c2103a160b307667115ad9d26e255.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_5873db221d9c2103a160b307667115ad9d26e255.rb
a = 1
a += 2 * 3
puts a
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_4e7ffb57c4f35f1f652f17e184bf8f98c3fe7aa0.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_4e7ffb57c4f35f1f652f17e184bf8f98c3fe7aa0.py
import sys

a = 1
a += 2 * 3
print(str(a))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_063849785025e3ef7a4fa482972a9e11f55f36a8.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_063849785025e3ef7a4fa482972a9e11f55f36a8.php
<?php

$a = 1;
$a += 2 * 3;
echo $a . "\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

echo perl
perl $ROONDA_TMP_PATH/roonda_f7e85e5c5ce2e038726432f2bd465e2b096d92d8.pl
echo ruby
ruby $ROONDA_TMP_PATH/roonda_5873db221d9c2103a160b307667115ad9d26e255.rb
echo python2
python2 $ROONDA_TMP_PATH/roonda_4e7ffb57c4f35f1f652f17e184bf8f98c3fe7aa0.py
echo python3
python3 $ROONDA_TMP_PATH/roonda_4e7ffb57c4f35f1f652f17e184bf8f98c3fe7aa0.py
echo php
php $ROONDA_TMP_PATH/roonda_063849785025e3ef7a4fa482972a9e11f55f36a8.php
