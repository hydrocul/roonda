#!/bin/sh

cd `dirname $0`

mkdir -p target

{
    cat ./src/head.pl
    cat ./src/const.pl
    cat ./src/global.pl
    cat ./src/version.pl
    cat ./src/sha1.pl
    cat ./src/save.pl
    cat ./src/astlib.pl
    cat ./src/st_common.pl
    cat ./src/parse_sexpr.pl
    cat ./src/parse_json.pl
    cat ./src/build_ast.pl
    cat ./src/langs.pl
    cat ./src/gen_obj.pl
    cat ./src/escape.pl
    cat ./src/gen_code.pl
    cat ./src/gen_stmt.pl
    cat ./src/gen_print.pl
    cat ./src/gen_if.pl
    cat ./src/gen_foreach.pl
    cat ./src/gen_expr.pl
    cat ./src/gen_var.pl
    cat ./src/gen_embed.pl
    cat ./src/gen_sh.pl
    cat ./src/gen_perl.pl
    cat ./src/build_by_template.pl
    cat ./src/main.pl
} > ./target/roonda

chmod 755 ./target/roonda


