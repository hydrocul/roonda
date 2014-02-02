
sub gent_langs {
    my ($token, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_PHP);
    if (astlib_is_list($token)) {
        genl_langs(astlib_get_list($token), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs {
    my ($list, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_PHP);
    my $result = '';
    if ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $result = $result . "import sys\n\n";
    }
    foreach my $elem (@$list) {
        my $source = gent_langs_statement($elem, '', $lang, $ver);
        $result = $result . $source;
    }
    return $result;
}

sub gent_langs_statement {
    my ($token, $indent, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_PHP);
    if (astlib_is_list($token)) {
        genl_langs_statement(astlib_get_list($token), $indent,
                             astlib_get_close_line_no($token), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs_statement {
    my ($list, $indent, $close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_PHP);
    if ($lang eq $LANG_SH) {
        return genl_sh_statement($list, $indent, $close_line_no, $ver);
    }
    my $head = shift(@$list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    my $expr_source;
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_IF) {
            die "TODO";
        } elsif ($token eq $KEYWD_PRINT) {
            $expr_source = genl_langs_print($list, $close_line_no, $lang, $ver);
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
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $indent . $expr_source . "\n";
    } else {
        die;
    }
}

sub genl_langs_print {
    my ($list, $close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_PHP);
    my $elem = shift(@$list);
    die create_dying_msg_unexpected_closing($close_line_no) unless ($elem);
    my $source = gent_langs_argument($elem, $OP_ORDER_ARG_COMMA, $lang, $ver);
    if ($lang eq $LANG_PERL) {
        "print $source";
    } elsif ($lang eq $LANG_RUBY) {
        "print $source";
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        "sys.stdout.write(str($source))";
    }
}

