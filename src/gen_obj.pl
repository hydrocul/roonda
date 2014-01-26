
sub gent_obj {
    my ($token, $lang, $ver) = @_;
    if (astlib_is_symbol_or_string($token)) {
        if ($lang eq $LANG_PERL) {
            escape_perl_string(astlib_get_symbol_or_string($token));
        } elsif ($lang eq $LANG_RUBY) {
            escape_ruby_string(astlib_get_symbol_or_string($token));
        } else {
            die;
        }
    } elsif (astlib_is_integer($token)) {
        astlib_get_integer($token);
    } elsif (astlib_is_list($token)) {
        my $list = astlib_get_list($token);
        my @list2 = ();
        foreach my $elem (@$list) {
            push(@list2, gent_obj($elem, $lang, $ver));
        }
        if ($lang eq $LANG_PERL) {
            '[' . join(',', @list2) . ']';
        } elsif ($lang eq $LANG_RUBY) {
            '[' . join(',', @list2) . ']';
        } else {
            die;
        }
    } else {
        die;
    }
}
