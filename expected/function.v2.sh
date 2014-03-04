#!/bin/sh

#################################################
# roonda_b24fff3df8ea4a7cf535c39191317e9c07720733.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_b24fff3df8ea4a7cf535c39191317e9c07720733.py
import sys

x = 10
def f (a, b):
    x = a + b
    print(str(x))

def g ():
    print(str(x))

f(3, 4)
g()
print(str(x))
END_OF_ROONDA_SOURCE_FILE
#################################################

echo python
python2 $ROONDA_TMP_PATH/roonda_b24fff3df8ea4a7cf535c39191317e9c07720733.py
