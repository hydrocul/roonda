#!/bin/sh

#################################################
# roonda_87d6e3012a55cddf0a8fad055c7b5910711ceeeb.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_87d6e3012a55cddf0a8fad055c7b5910711ceeeb.pl
use Encode qw/encode/;
use Data::Dumper;

print encode('utf-8', 3 + 4);
print encode('utf-8', "\n");
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_6d3de3dcc5db1990d4c45052b0ab3aab9534f38b.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_6d3de3dcc5db1990d4c45052b0ab3aab9534f38b.rb
print 3 + 4
print "\n"
END_OF_ROONDA_SOURCE_FILE
#################################################

perl $ROONDA_TMP_PATH/roonda_87d6e3012a55cddf0a8fad055c7b5910711ceeeb.pl
ruby $ROONDA_TMP_PATH/roonda_6d3de3dcc5db1990d4c45052b0ab3aab9534f38b.rb
