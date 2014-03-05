#!/bin/sh

#################################################
# roonda_90e248c74237161c6625536ebbfcb02261de89b1.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_90e248c74237161c6625536ebbfcb02261de89b1.py
import sys

import math
print(str(math.sin(1)))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_68693bdfffee70b770b3891c55768d693a85cf14.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_68693bdfffee70b770b3891c55768d693a85cf14.py
import sys

import math as m
print(str(m.sin(1)))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_0be4866e1da938074ee0cd30ec688d63b4295fb3.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_0be4866e1da938074ee0cd30ec688d63b4295fb3.py
import sys

from math import *
print(str(sin(1)))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_1c210073c25566eb501a2ac99fbdb3b10bc9e998.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_1c210073c25566eb501a2ac99fbdb3b10bc9e998.py
import sys

from math import sin
print(str(sin(1)))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_2c58149c8ad7f64a89322c14eab207d3dfbc3f85.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_2c58149c8ad7f64a89322c14eab207d3dfbc3f85.py
import sys

from os import path
print(str(path.basename("/aa/bb")))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_bee78b95619932e60446bac8e3ed1c9f682fa7a3.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_bee78b95619932e60446bac8e3ed1c9f682fa7a3.py
import sys

import os
print(str(os.path.basename("/aa/bb")))
END_OF_ROONDA_SOURCE_FILE
#################################################
# roonda_77fe8058b972f09ad411d003e227d7c5cef2cafd.py:
#################################################
cat <<\END_OF_ROONDA_SOURCE_FILE > $ROONDA_TMP_PATH/roonda_77fe8058b972f09ad411d003e227d7c5cef2cafd.py
import sys

import os.path
print(str(os.path.basename("/aa/bb")))
END_OF_ROONDA_SOURCE_FILE
#################################################

echo python
python2 $ROONDA_TMP_PATH/roonda_90e248c74237161c6625536ebbfcb02261de89b1.py
python2 $ROONDA_TMP_PATH/roonda_90e248c74237161c6625536ebbfcb02261de89b1.py
python2 $ROONDA_TMP_PATH/roonda_68693bdfffee70b770b3891c55768d693a85cf14.py
python2 $ROONDA_TMP_PATH/roonda_0be4866e1da938074ee0cd30ec688d63b4295fb3.py
python2 $ROONDA_TMP_PATH/roonda_1c210073c25566eb501a2ac99fbdb3b10bc9e998.py
python2 $ROONDA_TMP_PATH/roonda_2c58149c8ad7f64a89322c14eab207d3dfbc3f85.py
python2 $ROONDA_TMP_PATH/roonda_bee78b95619932e60446bac8e3ed1c9f682fa7a3.py
python2 $ROONDA_TMP_PATH/roonda_77fe8058b972f09ad411d003e227d7c5cef2cafd.py
