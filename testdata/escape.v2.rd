sh v2

# shだけの同様のテストはv1にもあり

(sh
 (print "Hello, world!\n")
 (print "Say \"Hello, world!\"\n")
 (print "\\\n")
 (print "\\nx\n")
 (print "あ\n"))

(perl
 (print "Hello, world!\n")
 (print "Say \"Hello, world!\"\n")
 (print "\\\n")
 (print "\\nx\n")
 (print "あ\n"))

(ruby
 (print "Hello, world!\n")
 (print "Say \"Hello, world!\"\n")
 (print "\\\n")
 (print "\\nx\n"))
# TODO utf8文字(perlのuse utf8のような宣言の機能)

(python2
 (print "Hello, world!\n")
 (print "Say \"Hello, world!\"\n")
 (print "\\\n")
 (print "\\nx\n"))
# TODO utf8文字(perlのuse utf8のような宣言の機能)

(python3
 (print "Hello, world!\n")
 (print "Say \"Hello, world!\"\n")
 (print "\\\n")
 (print "\\nx\n"))
# TODO utf8文字(perlのuse utf8のような宣言の機能)

(php
 (print "Hello, world!\n")
 (print "Say \"Hello, world!\"\n")
 (print "\\\n")
 (print "\\nx\n")
 (print "あ\n"))

