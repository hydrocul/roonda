sh v2

(println "python")
(python2
 (import () math)
 (println (apply (dot math sin) 1)))
(python2
 (import math *)
 (println (sin 1)))
(python2
 (import os path)
 (println (apply (dot path basename) "/aa/bb")))
(python2
 (import () os)
 (println (apply (dot os path basename) "/aa/bb")))
(python2
 (import () (os path))
 (println (apply (dot os path basename) "/aa/bb")))

