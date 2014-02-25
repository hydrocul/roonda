#!/bin/sh

#################################################
# roonda_9dc9cfd3b38b77561ec22b49a723432e26181003.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_9dc9cfd3b38b77561ec22b49a723432e26181003.sh
a=1
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_8c86cccde2fd62c0c6f58df7264f816024e014e5.pl:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_8c86cccde2fd62c0c6f58df7264f816024e014e5.pl
$a = 1;
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_31bd2185b0feac6e0c3da31b83b83819ef32a9a6.rb:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_31bd2185b0feac6e0c3da31b83b83819ef32a9a6.rb
a = 1
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_d52a235a0ffdd384b6c7ad2f2d80afa16fc6b585.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_d52a235a0ffdd384b6c7ad2f2d80afa16fc6b585.py
import sys

a = 1
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_46ab83445f7fc51c729babdbf21522658776674e.php:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_46ab83445f7fc51c729babdbf21522658776674e.php
<?php

$a = 1;
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_9dc9cfd3b38b77561ec22b49a723432e26181003.sh
perl $ROONDA_TMP_PATH/roonda_8c86cccde2fd62c0c6f58df7264f816024e014e5.pl
ruby $ROONDA_TMP_PATH/roonda_31bd2185b0feac6e0c3da31b83b83819ef32a9a6.rb
python2 $ROONDA_TMP_PATH/roonda_d52a235a0ffdd384b6c7ad2f2d80afa16fc6b585.py
python3 $ROONDA_TMP_PATH/roonda_d52a235a0ffdd384b6c7ad2f2d80afa16fc6b585.py
php $ROONDA_TMP_PATH/roonda_46ab83445f7fc51c729babdbf21522658776674e.php
