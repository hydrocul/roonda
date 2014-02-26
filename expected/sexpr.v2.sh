#!/bin/sh

#################################################
# attachedfile.txt:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/attachedfile.txt

Hello Hello

END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_c39258f878889e31cebbf69971813b0bb66640c0.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_c39258f878889e31cebbf69971813b0bb66640c0.pl
use Encode qw/encode/;

print encode('utf-8', "Hello\n");
END_OF_ROONDA_SOURCE_FILE
#################################################

echo Hello
echo Hello World
echo 'Hello   World!'
cat $ROONDA_TMP_PATH/attachedfile.txt
perl $ROONDA_TMP_PATH/roonda_c39258f878889e31cebbf69971813b0bb66640c0.pl
perl $ROONDA_TMP_PATH/roonda_c39258f878889e31cebbf69971813b0bb66640c0.pl
