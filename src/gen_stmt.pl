
# return: ($source, $istack)
sub gent_stmt_statements {
    my ($token, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    if (astlib_is_list($token)) {
        genl_stmt_statements(astlib_get_list($token), astlib_get_close_line_no($token),
                             $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub genl_stmt_statements {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    my $indent = istack_get_indent($istack);
    my $result = '';
    foreach my $elem (@$list) {
        my $source;
        ($source, $istack) = gent_stmt_statement($elem, $istack, $lang, $ver);
        $result = $result . "\n" . $indent if ($result);
        $result = $result . $source;
    }
    ($result, $istack);
}

# return: ($source, $istack)
sub gent_stmt_statement {
    my ($token, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    if (astlib_is_list($token)) {
        genl_stmt_statement(astlib_get_list($token),
                            astlib_get_close_line_no($token), $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub genl_stmt_statement {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    if ($lang eq $LANG_SH) {
        return genl_sh_statement($list, $list_close_line_no, $istack, $ver);
    }
    my $indent = istack_get_indent($istack); # TODO istack
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $source;
    if (astlib_is_symbol($head)) {
        ($source, $istack) =
            _genl_stmt_statement_head($head, \@list, $list_close_line_no, $istack, $lang, $ver);
    }
    if (!defined($source)) {
        ($source, $istack) =
            genl_expr($list, $list_close_line_no, $OP_ORDER_MIN, $istack, $lang, $ver);
    }
    die unless (defined($istack));
    if ($lang eq $LANG_PERL) {
        ($source . ";", $istack);
    } elsif ($lang eq $LANG_RUBY) {
        ($source, $istack);
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        ($source, $istack);
    } elsif ($lang eq $LANG_PHP) {
        ($source . ";", $istack);
    } else {
        die;
    }
}

# return: ($source, $istack)
sub _genl_stmt_statement_head {
    my ($head, $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (astlib_is_symbol($head));
    my $head_symbol = astlib_get_symbol($head);
    if ($head_symbol eq $KEYWD_IF) {
        genl_if($list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_FUNCTION) {
        if ($lang ne $LANG_PYTHON2 && $lang ne $LANG_PYTHON3) {
            die create_dying_msg_unexpected($head);
        }
        # TODO python以外でのfunction
        genl_function($list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_FOREACH) {
        genl_foreach($list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_PRINT) {
        genl_print($head_symbol, $list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_PRINTLN) {
        genl_print($head_symbol, $list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_DUMP) {
        genl_print($head_symbol, $list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_ASSIGN) {
        genl_var_assign($list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        (undef, $istack);
    }
}

