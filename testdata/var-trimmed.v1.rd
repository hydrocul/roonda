sh v1

(assign str "111 ")
(print (ref str))
(print "!\n")

(assign str "222\n")
(print (ref str))
(print "!\n")

(print (backticks echo -n "333 "))
(print "!\n")

