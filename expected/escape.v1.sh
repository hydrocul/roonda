#!/bin/sh

#################################################
# roonda_c1ee635619385ad9a559f9b6a845d10f6fdaf559.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_c1ee635619385ad9a559f9b6a845d10f6fdaf559.sh
echo -n 'Hello, world!
'
echo -n 'Say "Hello, world!"
'
echo -n '\\
'
echo -n '\\nx
'
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_c1ee635619385ad9a559f9b6a845d10f6fdaf559.sh
