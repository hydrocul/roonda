#!/bin/sh

#################################################
# roonda_16e4526e86ac3b9fb36516eb16be38ab1bad260f.sh:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_16e4526e86ac3b9fb36516eb16be38ab1bad260f.sh
echo -n 'Hello, world!
'
echo -n 'Say "Hello, world!"
'
END_OF_ROONDA_SOURCE_FILE
#################################################

sh $ROONDA_TMP_PATH/roonda_16e4526e86ac3b9fb36516eb16be38ab1bad260f.sh
