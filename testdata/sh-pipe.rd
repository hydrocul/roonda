(sh v1)

(pipe (echo "Hey!")
      (cat)
      ((perl) (print "Hello\n")))

(pipe (echo "abc")
      (> (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))
      (cat))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))

