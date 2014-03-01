sh v1
(echo Hello)
(echo Hello   World)
(echo "Hello   World!")

(cat attachedfile.txt)
(cat attachedfile-2.txt)
(cat attachedfile-3.txt)

<< attachedfile.txt

    Hello Hello

attachedfile.txt >>

<< attachedfile-2.txt

    Hello Hello 2

>> attachedfile-2.txt

<< attachedfile-3.txt \

    Hello Hello 3

>> attachedfile-3.txt

