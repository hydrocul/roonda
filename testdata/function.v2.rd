sh v2

(println "python")
(python2
 (assign x 10)
 (function f (a b)
           (assign x (+ a b))
           (println x))
 (function g ()
           (println x))
 (f 3 4)
 (g)
 (println x))

