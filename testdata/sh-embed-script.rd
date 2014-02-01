(sh v1)

(pipe (cat (strcat data.js))
      (roonda --json-1-to-python2-1))

(pipe (cat (strcat data.js))
      (roonda --json-to-python2))

(pipe (cat (strcat data.rd))
      (roonda --sexpr-to-python2))

<<data.js
[["abc", 10],
 ["def", 30],
 ["ghi", 100]]
data.js >>

<<data.rd
("abc" 10)
("def" 30)
("ghi" 100)
data.rd >>

