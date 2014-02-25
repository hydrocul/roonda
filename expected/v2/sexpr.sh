#!/bin/sh

#################################################
# attachedfile.txt:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/attachedfile.txt

Hello Hello

END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_3772d206f212590b290e2779a784416fef72956e.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_3772d206f212590b290e2779a784416fef72956e.pl
print "Hello\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

echo Hello
echo Hello World
echo 'Hello   World!'
cat $ROONDA_TMP_PATH/attachedfile.txt
perl $ROONDA_TMP_PATH/roonda_3772d206f212590b290e2779a784416fef72956e.pl
perl $ROONDA_TMP_PATH/roonda_3772d206f212590b290e2779a784416fef72956e.pl
