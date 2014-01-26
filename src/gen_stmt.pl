
sub gent_langs {
    my ($token_ref, $lang, $ver) = @_;
    if (astlib_is_list($token_ref)) {
        genl_langs(astlib_get_list($token_ref), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub genl_langs {
    my ($list_ref, $lang, $ver) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = gent_langs_statement($head, $lang, $ver);
        $result = $result . $source . "\n";
    }
}

sub gent_langs_statement {
    my ($token_ref, $lang, $ver) = @_;
    if (astlib_is_list($token_ref)) {
        genl_langs_statement(astlib_get_list($token_ref), astlib_get_close_line_no($token_ref), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub genl_langs_statement {
    my ($list_ref, $close_line_no, $lang, $ver) = @_;
    if ($lang eq $LANG_SH) {
        return genl_sh_statement($list_ref, $close_line_no, $ver);
    }
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    my $expr_source;
    if (astlib_is_symbol_or_string($head)) {
        if (astlib_get_symbol_or_string($head) eq $KEYWD_IF) {
            die "TODO";
        } else {
            unshift(@list, $head);
            $expr_source = genl_langs_expr(\@list, $OP_ORDER_MIN, $close_line_no, $lang);
        }
    } else {
        unshift(@list, $head);
        $expr_source = genl_langs_expr(\@list, $OP_ORDER_MIN, $close_line_no, $lang);
    }
    if ($lang eq $LANG_PERL) {
        $expr_source . ';';
    } elsif ($lang eq $LANG_RUBY) {
        $expr_source;
    } else {
        die;
    }
}

