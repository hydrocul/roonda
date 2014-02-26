
sub gent_obj {
    my ($token, $lang, $ver) = @_;
    if (astlib_is_symbol_or_string($token)) {
        if ($lang eq $LANG_SEXPR) {
            escape_sexpr_string(astlib_get_symbol_or_string($token));
        } elsif ($lang eq $LANG_PERL) {
            # TODO use utf8 のチェック
            escape_perl_string(astlib_get_symbol_or_string($token));
        } elsif ($lang eq $LANG_RUBY) {
            escape_ruby_string(astlib_get_symbol_or_string($token));
        } elsif ($lang eq $LANG_PYTHON2) {
            escape_python2_string(astlib_get_symbol_or_string($token));
        } elsif ($lang eq $LANG_PYTHON3) {
            escape_python3_string(astlib_get_symbol_or_string($token));
        } elsif ($lang eq $LANG_PHP) {
            escape_php_string(astlib_get_symbol_or_string($token));
        } else {
            die;
        }
    } elsif (astlib_is_integer($token)) {
        astlib_get_integer($token);
    } elsif (astlib_is_list($token)) {
        my $list = astlib_get_list($token);
        genl_obj($list, $lang, $ver);
    } else {
        die;
    }
}

sub genl_obj {
    my ($list, $lang, $ver) = @_;
    my @list2 = ();
    foreach my $elem (@$list) {
        push(@list2, gent_obj($elem, $lang, $ver));
    }
    if ($lang eq $LANG_SEXPR) {
        '(' . join(' ', @list2) . ')';
    } elsif ($lang eq $LANG_PERL) {
        '[' . join(',', @list2) . ']';
    } elsif ($lang eq $LANG_RUBY) {
        '[' . join(',', @list2) . ']';
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        '[' . join(',', @list2) . ']';
    } elsif ($lang eq $LANG_PHP) {
        'array(' . join(',', @list2) . ')';
    } else {
        die;
    }
}

