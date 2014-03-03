#!/bin/sh

#################################################
# roonda_6762454fed441f8793e447c3f317c5c8120c2a2b.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_6762454fed441f8793e447c3f317c5c8120c2a2b.pl
use Encode qw/encode/;
use Data::Dumper;

my $lst = [10 , 20 , 30];
foreach my $elem (@{$lst}) {
    print encode('utf-8', $elem . "\n");
    print encode('utf-8', $elem . "\n");
};
foreach my $elem (@{[100 , 200 , 300]}) {
    print encode('utf-8', $elem . "\n");
};
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_64db041410db0128a109007f59056e05488695b8.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_64db041410db0128a109007f59056e05488695b8.rb
lst = [10 , 20 , 30]
for elem in lst do
  puts elem
  puts elem
end
for elem in [100 , 200 , 300] do
  puts elem
end
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_69ba6c52cb489b3f9133e7fb38eadf8e621d4ba7.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_69ba6c52cb489b3f9133e7fb38eadf8e621d4ba7.py
import sys

lst = [10 , 20 , 30]
for elem in lst:
    print(str(elem))
    print(str(elem))
for elem in [100 , 200 , 300]:
    print(str(elem))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_780d8ef021d65efa4ffbd2e8417cea8a43f37143.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_780d8ef021d65efa4ffbd2e8417cea8a43f37143.php
<?php

$lst = array(10 , 20 , 30);
foreach ($lst as $elem) {
    echo $elem . "\n";
    echo $elem . "\n";
};
foreach (array(100 , 200 , 300) as $elem) {
    echo $elem . "\n";
};
END_OF_ROONDA_SOURCE_FILE
#################################################

echo perl
perl $ROONDA_TMP_PATH/roonda_6762454fed441f8793e447c3f317c5c8120c2a2b.pl
echo ruby
ruby $ROONDA_TMP_PATH/roonda_64db041410db0128a109007f59056e05488695b8.rb
echo python2
python2 $ROONDA_TMP_PATH/roonda_69ba6c52cb489b3f9133e7fb38eadf8e621d4ba7.py
echo python3
python3 $ROONDA_TMP_PATH/roonda_69ba6c52cb489b3f9133e7fb38eadf8e621d4ba7.py
echo php
php $ROONDA_TMP_PATH/roonda_780d8ef021d65efa4ffbd2e8417cea8a43f37143.php
