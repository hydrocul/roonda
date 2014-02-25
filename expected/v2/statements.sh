#!/bin/sh

#################################################
# roonda_684709aa769bd5d9ca52f76a55441efcbaaf5f01.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_684709aa769bd5d9ca52f76a55441efcbaaf5f01.sh
if echo a > /dev/null; then
    echo -n 'Hello '
    echo -n 'World!
'
else
    echo -n 'ELSE
'
fi
if ls /dummy 2> /dev/null; then
    echo -n 'TRUE
'
else
    echo -n 'OK
'
fi
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_588d5ace0aacf7da9baf21f7422bd6ed63b5007d.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_588d5ace0aacf7da9baf21f7422bd6ed63b5007d.pl
if (1) {
    print "Hello ";
    print "World!\n";
} else {
    print "ELSE\n";
};
if ('') {
    print "TRUE\n";
} else {
    print "OK\n";
};
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_f2938991edc48ead7fce2ca06e77c029fee9e60a.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_f2938991edc48ead7fce2ca06e77c029fee9e60a.rb
if true
  print "Hello "
  print "World!\n"
else
  print "ELSE\n"
end
if false
  print "TRUE\n"
else
  print "OK\n"
end
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_12490481c77aebd09586d30180bdde28cf0edd69.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_12490481c77aebd09586d30180bdde28cf0edd69.py
import sys

if True:
    sys.stdout.write(str("Hello "))
    sys.stdout.write(str("World!\n"))
else:
    sys.stdout.write(str("ELSE\n"))
if False:
    sys.stdout.write(str("TRUE\n"))
else:
    sys.stdout.write(str("OK\n"))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_85c77d448806654da7960a34cc66c1560357b2be.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_85c77d448806654da7960a34cc66c1560357b2be.php
<?php

if (TRUE) {
    echo "Hello ";
    echo "World!\n";
} else {
    echo "ELSE\n";
};
if (FALSE) {
    echo "TRUE\n";
} else {
    echo "OK\n";
};
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_684709aa769bd5d9ca52f76a55441efcbaaf5f01.sh
perl $ROONDA_TMP_PATH/roonda_588d5ace0aacf7da9baf21f7422bd6ed63b5007d.pl
ruby $ROONDA_TMP_PATH/roonda_f2938991edc48ead7fce2ca06e77c029fee9e60a.rb
python2 $ROONDA_TMP_PATH/roonda_12490481c77aebd09586d30180bdde28cf0edd69.py
python3 $ROONDA_TMP_PATH/roonda_12490481c77aebd09586d30180bdde28cf0edd69.py
php $ROONDA_TMP_PATH/roonda_85c77d448806654da7960a34cc66c1560357b2be.php
