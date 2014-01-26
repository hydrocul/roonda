
sub gent_langs {
    my ($token, $lang, $ver) = @_;
    if (astlib_is_list($token)) {
        genl_langs(astlib_get_list($token), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs {
    my ($list, $lang, $ver) = @_;
    my $result = '';
    foreach my $elem (@$list) {
        my $source = gent_langs_statement($elem, '', $lang, $ver);
        $result = $result . $source;
    }
    return $result;
}

sub gent_langs_statement {
    my ($token, $indent, $lang, $ver) = @_;
    if (astlib_is_list($token)) {
        genl_langs_statement(astlib_get_list($token), $indent,
                             astlib_get_close_line_no($token), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs_statement {
    my ($list, $indent, $close_line_no, $lang, $ver) = @_;
    if ($lang eq $LANG_SH) {
        return genl_sh_statement($list, $indent, $close_line_no, $ver);
    }
    my $head = shift(@$list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    my $expr_source;
    if (astlib_is_symbol_or_string($head)) {
        if (astlib_get_symbol_or_string($head) eq $KEYWD_IF) {
            die "TODO";
        } else {
            unshift(@$list, $head);
            $expr_source = genl_langs_expr($list, $OP_ORDER_MIN, $close_line_no, $lang);
        }
    } else {
        unshift(@$list, $head);
        $expr_source = genl_langs_expr($list, $OP_ORDER_MIN, $close_line_no, $lang);
    }
    if ($lang eq $LANG_PERL) {
        $indent . $expr_source . ";\n";
    } elsif ($lang eq $LANG_RUBY) {
        $indent . $expr_source . "\n";
    } else {
        die;
    }
}

