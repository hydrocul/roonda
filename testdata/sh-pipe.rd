(sh v1)

(pipe (echo "Hey!")
      (cat)
      ((perl v1) (print "Hello\n")))

