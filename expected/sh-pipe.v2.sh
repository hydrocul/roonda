#!/bin/sh

#################################################
# roonda_35f667a5ef6b240dccabee366adf62baceeec361.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_35f667a5ef6b240dccabee366adf62baceeec361.pl
use Encode qw/encode/;
use Data::Dumper;

print encode('utf-8', "Hello\n");
END_OF_ROONDA_SOURCE_FILE
#################################################

echo 'Hey!' | cat | perl $ROONDA_TMP_PATH/roonda_35f667a5ef6b240dccabee366adf62baceeec361.pl
echo abc > "$ROONDA_TMP_PATH"/abc.txt
cat < "$ROONDA_TMP_PATH"/abc.txt | cat
cat < "$ROONDA_TMP_PATH"/abc.txt
cat "$ROONDA_TMP_PATH"/abc.txt | tee "$ROONDA_TMP_PATH"/abc1.txt > "$ROONDA_TMP_PATH"/abc2.txt
cat < "$ROONDA_TMP_PATH"/abc1.txt
echo ABC >> "$ROONDA_TMP_PATH"/abc2.txt
cat < "$ROONDA_TMP_PATH"/abc2.txt
