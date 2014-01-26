#!/bin/sh

cd `dirname $0`

mkdir -p target

{
    cat ./src/head.pl
    cat ./src/const.pl
    cat ./src/save.pl
    cat ./src/astlib.pl
    cat ./src/parse_sexpr.pl
    cat ./src/parse_json.pl
    cat ./src/build_ast.pl
    cat ./src/gen_obj.pl
    cat ./src/escape.pl
    cat ./src/eatast_exec.pl
    cat ./src/eatast_langs.pl
    cat ./src/eatast_sh.pl
    cat ./src/eatast_perl.pl
    cat ./src/main.pl
} > ./target/roonda

chmod 755 ./target/roonda


