sh v2

(pipe (cat data.js)
      (roonda --v1 --json-to-python2-obj))

(pipe (cat data.rd)
      (roonda --v1 --sexpr-to-python2-obj))

(pipe (cat data.js)
      (roonda --v1 --from-json --to-sexpr-obj))

(pipe (cat data.js)
      (roonda json-to-python2))

(pipe (cat data.js)
      (roonda json-to-sexpr))

(pipe (cat data.js)
      (roonda --v2 pipe.rd))

# TODO
#(pipe (cat data.js)
#      (roonda json-to-python2 ()
#       (print (stdin_data json))
#       (print "\n")))


<< data.js
[["abc", 10],
 ["def", 30],
 ["ghi", 100]]
data.js >>

<< data.rd
("abc" 10)
("def" 30)
("ghi" 100)
data.rd >>

<< pipe.rd
python2 v2
(print (stdin_data json))
(print "\n")
pipe.rd >>
