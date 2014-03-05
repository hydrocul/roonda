sh v2

(python2
 (println 123e45)
 (println 123e+45)
 (println 123e-45)
 (println 123.e45)
 (println 123.e+45)
 (println 123.e-45)
 (println 123.0e45)
 (println 123.0e+45)
 (println 123.0e-45)
 (println 0.123e45)
 (println 0.123e+45)
 (println 0.123e-45)
 )

(println "perl")
(perl
 (assign p 3.1416)
 (println (* 2 2.5 3.5)))

(println "ruby")
(ruby
 (assign p 3.1416)
 (println (* 2 2.5 3.5)))

(println "python2")
(python2
 (assign p 3.1416)
 (println (* 2 2.5 3.5)))

(println "python3")
(python3
 (assign p 3.1416)
 (println (* 2 2.5 3.5)))

(println "php")
(php
 (assign p 3.1416)
 (println (* 2 2.5 3.5)))

