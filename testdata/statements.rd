sh v1

(sh
 (if (echo "a" (> "/dev/null"))
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if (ls "/dummy" (> 2 "/dev/null"))
     ((print "TRUE\n"))
     ((print "OK\n")))
 (assign a 1))
(perl
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n")))
 (assign a 1))
(ruby
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n")))
 (assign a 1))
(python2
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n")))
 (assign a 1))
(python3
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n")))
 (assign a 1))
(php
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n")))
 (assign a 1))
