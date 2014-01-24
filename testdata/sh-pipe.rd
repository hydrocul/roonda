(sh v1)

(pipe (echo "Hey!")
      (cat)
      ((perl v1) (print "Hello\n")))

(pipe (echo "abc")
      (> (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))
      (cat))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))

