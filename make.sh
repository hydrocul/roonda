#!/bin/sh

cd `dirname $0`

mkdir -p target

{
    cat ./src/head.pl
    cat ./src/const.pl
    cat ./src/save.pl
    cat ./src/parse_source.pl
    cat ./src/build_sexpr.pl
    cat ./src/escape.pl
    cat ./src/eat_sexpr_exec.pl
    cat ./src/eat_sexpr_langs.pl
    cat ./src/eat_sexpr_sh.pl
    cat ./src/eat_sexpr_perl.pl
    cat ./src/main.pl
} > ./target/roonda

chmod 755 ./target/roonda


