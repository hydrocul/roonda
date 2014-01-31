(sh v1)

(pipe (echo "[[\"abc\", 10], [\"def\", 30]]")
      ((ref ROONDA_SELF_PATH) --from-json-1 --to-python2-obj-1))

(pipe (echo "[[\"abc\", 10], [\"def\", 30]]")
      (roonda --from-json-1 --to-python2-obj-1))

