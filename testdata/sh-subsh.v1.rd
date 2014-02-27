sh v1

(subsh (echo "a")
       (echo "b"))

(pipe (subsh (echo "a")
             (echo "b"))
      (cat))

(if (echo "a" (> "/dev/null"))
    ((subsh (echo "if-t-a")
            (echo "if-t-b")))
    ((subsh (echo "if-f-a")
            (echo "if-f-b"))))

(group (echo "a")
       (echo "b"))

(pipe (group (echo "a")
             (echo "b"))
      (cat))

(if (echo "a" (> "/dev/null"))
    ((group (echo "if-t-a")
            (echo "if-t-b")))
    ((group (echo "if-f-a")
            (echo "if-f-b"))))

