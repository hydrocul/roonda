sh v2

(println "perl")
(perl
 (assign lst (list 10 20 30))
 (foreach elem lst
          (println (ref elem))
          (println elem))
 (foreach elem (list 100 200 300)
          (println elem)))

(println "ruby")
(ruby
 (assign lst (list 10 20 30))
 (foreach elem lst
          (println (ref elem))
          (println elem))
 (foreach elem (list 100 200 300)
          (println elem)))

(println "python2")
(python2
 (assign lst (list 10 20 30))
 (foreach elem lst
          (println (ref elem))
          (println elem))
 (foreach elem (list 100 200 300)
          (println elem)))

(println "python3")
(python3
 (assign lst (list 10 20 30))
 (foreach elem lst
          (println (ref elem))
          (println elem))
 (foreach elem (list 100 200 300)
          (println elem)))

(println "php")
(php
 (assign lst (list 10 20 30))
 (foreach elem lst
          (println (ref elem))
          (println elem))
 (foreach elem (list 100 200 300)
          (println elem)))

