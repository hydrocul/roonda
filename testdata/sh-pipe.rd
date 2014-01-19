(sh)

(pipe (echo "Hey!")
      (cat)
      ((perl) (print "Hello\n")))

