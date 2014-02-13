(sh v1)

(pipe (echo "Hey!")
      (cat)
      ((perl) (print "Hello\n")))

(pipe (echo "abc"
      (> (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))))

(pipe (cat (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt)))
      (cat))

(pipe (cat (< (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))))

(pipe (cat (strcat (ref ROONDA_TMP_PATH) "/" abc.txt))
      (tee (strcat (ref ROONDA_TMP_PATH) "/" abc1.txt) (> (strcat (ref ROONDA_TMP_PATH) "/" abc2.txt))))

(pipe (cat (< (strcat (ref ROONDA_TMP_PATH) "/" abc1.txt))))

(pipe (echo "ABC"
      (>> (strcat (ref ROONDA_TMP_PATH) "/" abc2.txt))))

(pipe (cat (< (strcat (ref ROONDA_TMP_PATH) "/" abc2.txt))))

