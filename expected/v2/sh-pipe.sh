#!/bin/sh

#################################################
# roonda_3772d206f212590b290e2779a784416fef72956e.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_3772d206f212590b290e2779a784416fef72956e.pl
print "Hello\n";
END_OF_ROONDA_SOURCE_FILE
#################################################

echo 'Hey!' | cat | perl $ROONDA_TMP_PATH/roonda_3772d206f212590b290e2779a784416fef72956e.pl
echo abc > "$ROONDA_TMP_PATH"/abc.txt
cat < "$ROONDA_TMP_PATH"/abc.txt | cat
cat < "$ROONDA_TMP_PATH"/abc.txt
cat "$ROONDA_TMP_PATH"/abc.txt | tee "$ROONDA_TMP_PATH"/abc1.txt > "$ROONDA_TMP_PATH"/abc2.txt
cat < "$ROONDA_TMP_PATH"/abc1.txt
echo ABC >> "$ROONDA_TMP_PATH"/abc2.txt
cat < "$ROONDA_TMP_PATH"/abc2.txt