sh v2

(sh
 (if (echo "a" (> "/dev/null"))
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if (ls "/dummy" (> 2 "/dev/null"))
     ((print "TRUE\n"))
     ((print "OK\n"))))
(perl
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n"))))
(ruby
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n"))))
(python2
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n"))))
(python3
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n"))))
(php
 (if true
     ((print "Hello ")
      (print "World!\n"))
     ((print "ELSE\n")))
 (if false
     ((print "TRUE\n"))
     ((print "OK\n"))))
