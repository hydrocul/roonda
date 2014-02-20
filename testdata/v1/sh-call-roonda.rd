sh v1

(pipe (echo "[[\"abc\", 10], [\"def\", 30]]")
      ((ref ROONDA_SELF_PATH) --v1 --from-json --to-python2-obj))

(pipe (echo "[[\"abc\", 10], [\"def\", 30]]")
      (roonda --v1 --from-json --to-python2-obj))

