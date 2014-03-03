sh v1

(assign TEST_ENV1 "Hello 1")
(assign TEST_ENV2 "Hello 2")
(export TEST_ENV2)
(sh main.sh)

<< main.sh

echo $TEST_ENV1
echo $TEST_ENV2

>> main.sh

