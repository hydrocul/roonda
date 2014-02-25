
#################################################
# roonda_d9a5eb41997df78774f28ed5ca9301fb407663c2.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_d9a5eb41997df78774f28ed5ca9301fb407663c2.pl
print 3 + 4;
print "\n";
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_6d3de3dcc5db1990d4c45052b0ab3aab9534f38b.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_6d3de3dcc5db1990d4c45052b0ab3aab9534f38b.rb
print 3 + 4
print "\n"
END_OF_ROONDA_SOURCE_FILE
#################################################

perl $ROONDA_TMP_PATH/roonda_d9a5eb41997df78774f28ed5ca9301fb407663c2.pl
ruby $ROONDA_TMP_PATH/roonda_6d3de3dcc5db1990d4c45052b0ab3aab9534f38b.rb
