(sh v1)

(pipe (cat data.js)
      (roonda --v1 --json-to-python2))

(pipe (cat data.rd)
      (roonda --v1 --sexpr-to-python2))

(pipe (cat data.js)
      (roonda --v1 --json-to-python2 --replace-tag ROONDA_STDIN_DATA --output-code script.py))

(pipe (cat data.js)
      (roonda --v1 --json-to-python2 --replace-tag ROONDA_STDIN_DATA script.py))

(pipe (cat data.js)
      (roonda --v1 --json-to-python2 script2.py))

(pipe (cat data.js)
      (roonda json-to-python2))

(pipe (cat data.js)
      (roonda json-to-python2 script2.py))

(pipe (cat data.js)
      (roonda json-to-python2 ()
       (print stdin_data)
       (print "\n")))

(pipe (cat data.js)
      (roonda --v1 --from-json --to-sexpr-obj))

(pipe (cat data.js)
      (roonda json-to-sexpr))


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

<< script.py
print(ROONDA_STDIN_DATA)
script.py >>

<< script2.py
print(stdin_data)
script2.py >>

