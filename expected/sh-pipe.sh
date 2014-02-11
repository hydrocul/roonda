echo 'Hey!' | cat | perl $ROONDA_TMP_PATH/roonda_3772d206f212590b290e2779a784416fef72956e.pl
echo abc > $ROONDA_TMP_PATH/abc.txt
cat $ROONDA_TMP_PATH/abc.txt | cat
cat $ROONDA_TMP_PATH/abc.txt
cat $ROONDA_TMP_PATH/abc.txt| tee $ROONDA_TMP_PATH/abc1.txt > $ROONDA_TMP_PATH/abc2.txt
cat $ROONDA_TMP_PATH/abc1.txt
cat $ROONDA_TMP_PATH/abc2.txt

#################################################
# roonda_3772d206f212590b290e2779a784416fef72956e.pl:
#################################################
# print "Hello\n";
