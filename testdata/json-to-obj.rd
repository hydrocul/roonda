sh v1

(pipe (cat data.js)
      (roonda json-to-perl))
(pipe (cat data.js)
      (roonda json-to-ruby))
(pipe (cat data.js)
      (roonda json-to-python2))
(pipe (cat data.js)
      (roonda json-to-python3))
(pipe (cat data.js)
      (roonda json-to-php))

<< data.js
[["abc", "Hey", 10],
 ["def", "Hello", 30],
 ["ghi", "Hello", 50],
 ["jk", "Hello   World!", 100]]
data.js >>
