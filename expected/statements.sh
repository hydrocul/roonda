sh $ROONDA_TMP_PATH/roonda_10b406470bfc84c18505a9df7fce664e86e1cd1d.sh
perl $ROONDA_TMP_PATH/roonda_d90b9a16e1ec8f110a409de91a92a169a165c7a6.pl
ruby $ROONDA_TMP_PATH/roonda_49c34db6f9e2988a59fdb2396271536772557432.rb
python2 $ROONDA_TMP_PATH/roonda_7ad86add5fc51cffcebc2c15579d547d06cb60d9.py
python3 $ROONDA_TMP_PATH/roonda_7ad86add5fc51cffcebc2c15579d547d06cb60d9.py
php $ROONDA_TMP_PATH/roonda_1100ff5b34bdcf944baf7fa633c5765979250b2f.php

#################################################
# roonda_10b406470bfc84c18505a9df7fce664e86e1cd1d.sh:
#################################################
# if echo a > /dev/null; then
#     echo -n 'Hello '
#     echo -n 'World!
# '
# else
#     echo -n 'ELSE
# '
# fi
# if ls /dummy 2> /dev/null; then
#     echo -n 'TRUE
# '
# else
#     echo -n 'OK
# '
# fi
# a=1

#################################################
# roonda_d90b9a16e1ec8f110a409de91a92a169a165c7a6.pl:
#################################################
# if (1) {
#     print "Hello ";
#     print "World!\n";
# } else {
#     print "ELSE\n";
# };
# if ('') {
#     print "TRUE\n";
# } else {
#     print "OK\n";
# };
# $a = 1;

#################################################
# roonda_49c34db6f9e2988a59fdb2396271536772557432.rb:
#################################################
# if true
#   print "Hello "
#   print "World!\n"
# else
#   print "ELSE\n"
# end
# if false
#   print "TRUE\n"
# else
#   print "OK\n"
# end
# a = 1

#################################################
# roonda_7ad86add5fc51cffcebc2c15579d547d06cb60d9.py:
#################################################
# import sys
# 
# if True:
#     sys.stdout.write(str("Hello "))
#     sys.stdout.write(str("World!\n"))
# else:
#     sys.stdout.write(str("ELSE\n"))
# if False:
#     sys.stdout.write(str("TRUE\n"))
# else:
#     sys.stdout.write(str("OK\n"))
# a = 1

#################################################
# roonda_1100ff5b34bdcf944baf7fa633c5765979250b2f.php:
#################################################
# <?php
# 
# if (TRUE) {
#     echo "Hello ";
#     echo "World!\n";
# } else {
#     echo "ELSE\n";
# };
# if (FALSE) {
#     echo "TRUE\n";
# } else {
#     echo "OK\n";
# };
# $a = 1;
