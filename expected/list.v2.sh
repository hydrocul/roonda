#!/bin/sh

#################################################
# roonda_9f76b7aa46cd9e1fe27f32f8b39eb460cd69079b.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_9f76b7aa46cd9e1fe27f32f8b39eb460cd69079b.pl
use Encode qw/encode/;
use Data::Dumper;

my $lst = [1 , 2 , 3 , "abc"];
print Dumper($lst);
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_62f34597987cf2e3fbefd804c6863398537c4caa.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_62f34597987cf2e3fbefd804c6863398537c4caa.rb
lst = [1 , 2 , 3 , "abc"]
p lst
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_dda5e399bb9d0082026a901daf4b7b81b721b914.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_dda5e399bb9d0082026a901daf4b7b81b721b914.py
import sys

lst = [1 , 2 , 3 , "abc"]
print(lst)
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_0c6ed6dbbabda94e41c567018f637a6f90c354e4.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_0c6ed6dbbabda94e41c567018f637a6f90c354e4.php
<?php

$lst = array(1 , 2 , 3 , "abc");
var_export($lst);
END_OF_ROONDA_SOURCE_FILE
#################################################

echo perl
perl $ROONDA_TMP_PATH/roonda_9f76b7aa46cd9e1fe27f32f8b39eb460cd69079b.pl
echo ruby
ruby $ROONDA_TMP_PATH/roonda_62f34597987cf2e3fbefd804c6863398537c4caa.rb
echo python2
python2 $ROONDA_TMP_PATH/roonda_dda5e399bb9d0082026a901daf4b7b81b721b914.py
echo python3
python3 $ROONDA_TMP_PATH/roonda_dda5e399bb9d0082026a901daf4b7b81b721b914.py
echo php
php $ROONDA_TMP_PATH/roonda_0c6ed6dbbabda94e41c567018f637a6f90c354e4.php
