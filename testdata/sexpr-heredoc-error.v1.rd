sh v1

(pipe (cat test.roonda)
      (roonda --dry-run (> 2 "/dev/null")))

(if ("[" (ref "?") "=" 0 "]")
    ((echo "success"))
    ((echo "roonda execution error")))


<< test.roonda
sh v1

(cat attachedfile.txt)

<< attachedfile.txt

aaa

test.roonda >>
