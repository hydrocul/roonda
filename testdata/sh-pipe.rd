(sh v1)

(pipe (echo "Hey!")
      (cat)
      ((perl) (print "Hello\n")))

(pipe (echo "abc")
      (> (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))
      (cat))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))
      (> (strcat (ref ROONDA_TMP_PATH) "/" abc1.txt) (strcat (ref ROONDA_TMP_PATH) "/" abc2.txt)))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc1.txt)))

(pipe (echo "ABC")
      (>> (strcat (ref ROONDA_TMP_PATH) "/" abc2.txt)))

(pipe (< (strcat (ref ROONDA_TMP_PATH) "/" abc2.txt)))

