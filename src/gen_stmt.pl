
sub gent_langs_statements {
    my ($token, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if (astlib_is_list($token)) {
        genl_langs_statements(astlib_get_list($token),
                              astlib_get_close_line_no($token), $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs_statements {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $indent = istack_get_indent($istack);
    my $result = '';
    foreach my $elem (@$list) {
        my $source = gent_langs_statement($elem, $istack, $lang, $ver);
        $result = $result . "\n" . $indent if ($result);
        $result = $result . $source;
    }
    $result;
}

sub gent_langs_statement {
    my ($token, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if (astlib_is_list($token)) {
        genl_langs_statement(astlib_get_list($token),
                             astlib_get_close_line_no($token), $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs_statement {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if ($lang eq $LANG_SH) {
        return genl_sh_statement($list, $istack, $list_close_line_no, $ver);
    }
    my $indent = istack_get_indent($istack); # TODO istack
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $expr_source;
    if (astlib_is_symbol($head)) {
        my $symbol = astlib_get_symbol($head);
        if ($symbol eq $KEYWD_IF) {
            $expr_source = genl_langs_if(\@list, $list_close_line_no, $istack, $lang, $ver);
        } elsif ($symbol eq $KEYWD_PRINT) {
            $expr_source = genl_langs_print(\@list, $list_close_line_no, $istack, $lang, $ver);
        } elsif ($symbol eq $KEYWD_ASSIGN) {
            $expr_source = genl_langs_assign(\@list, $list_close_line_no, $istack, $lang, $ver);
        }
    }
    if (!defined($expr_source)) {
        unshift(@list, $head);
        $expr_source = genl_langs_expr(\@list, $OP_ORDER_MIN, $list_close_line_no, $istack, $lang, $ver);
    }
    if ($lang eq $LANG_PERL) {
        $expr_source . ";";
    } elsif ($lang eq $LANG_RUBY) {
        $expr_source;
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $expr_source;
    } elsif ($lang eq $LANG_PHP) {
        $expr_source . ";";
    } else {
        die;
    }
}

sub genl_langs_if {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $cond_istack = istack_append_indent($istack, get_source_indent($lang, $ver));
    my $then_istack = istack_append_indent($istack, get_source_indent($lang, $ver));
    my $then_indent = istack_get_indent($then_istack);
    my @list = @$list;
    my $cond_elem = shift(@list);
    unless (defined($cond_elem)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $then_elem = shift(@list);
    unless (defined($then_elem)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $else_elem = shift(@list);
    if (@list) {
        die create_dying_msg_unexpected(shift(@list));
    }
    my $indent = istack_get_indent($istack); # TODO

    my $cond_source;
    if ($lang eq $LANG_SH) {
        $cond_source = gent_sh_command($cond_elem, '', '', '', 1, '', $ver); # TODO istack
    } else {
        $cond_source = gent_langs_expr($cond_elem, $OP_ORDER_MIN, $cond_istack, $lang, $ver);
    }
    my $then_source = gent_langs_statements($then_elem, $then_istack, $lang, $ver);
    if (defined($else_elem)) {
        my $else_source = gent_langs_statements($else_elem, $then_istack, $lang, $ver);
        if ($lang eq $LANG_SH) {
            "if $cond_source; then\n$then_indent$then_source\n${indent}else\n$then_indent$else_source\n${indent}fi";
        } elsif ($lang eq $LANG_PERL) {
            "if ($cond_source) {\n$then_indent$then_source\n$indent} else {\n$then_indent$else_source\n$indent}";
        } elsif ($lang eq $LANG_RUBY) {
            "if $cond_source\n$then_indent$then_source\n${indent}else\n$then_indent$else_source\n${indent}end";
        } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
            "if $cond_source:\n$then_indent$then_source\nelse:\n$then_indent$else_source";
        } elsif ($lang eq $LANG_PHP) {
            "if ($cond_source) {\n$then_indent$then_source\n$indent} else {\n$then_indent$else_source\n$indent}";
        } else {
            die;
        }
    } else {
        if ($lang eq $LANG_SH) {
            "if $cond_source; then\n$then_indent$then_source\n${indent}fi";
        } elsif ($lang eq $LANG_PERL) {
            "if ($cond_source) {\n$then_indent$then_source\n$indent}";
        } elsif ($lang eq $LANG_RUBY) {
            "if $cond_source\n$then_indent$then_source\n${indent}end";
        } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
            "if $cond_source:\n$then_indent$then_source";
        } elsif ($lang eq $LANG_PHP) {
            "if ($cond_source) {\n$then_indent$then_source\n$indent}";
        } else {
            die;
        }
    }
}

sub genl_langs_print {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $elem = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless ($elem);
    my $source;
    if ($lang eq $LANG_SH) {
        $source = gent_sh_argument($elem, $ver);
    } else {
        $source = gent_langs_expr($elem, $OP_ORDER_ARG_COMMA, $istack, $lang, $ver);
    }
    if ($lang eq $LANG_SH) {
        "echo -n $source";
    } elsif ($lang eq $LANG_PERL) {
        "print $source";
    } elsif ($lang eq $LANG_RUBY) {
        "print $source";
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        "sys.stdout.write(str($source))";
    } elsif ($lang eq $LANG_PHP) {
        "echo $source";
    } else {
        die;
    }
}

sub genl_langs_assign {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    if (astlib_is_symbol($head)) {
        genl_langs_assign_1(astlib_get_symbol($head), \@list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_assign_1 {
    my ($varname, $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if ($lang eq $LANG_SH) {
        return genl_sh_assign_1($varname, $list, $list_close_line_no, $istack, $ver);
    }
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    die create_dying_msg_unexpected(shift(@list)) if (@list);
    my $source = gent_langs_expr($head, $OP_ORDER_MIN, $istack, $lang, $ver);
    my $result;
    if ($lang eq $LANG_PERL) {
        $result = '$' . $varname . ' = ' . $source;
    } elsif ($lang eq $LANG_RUBY) {
        $result = $varname . ' = ' . $source;
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $result = $varname . ' = ' . $source;
    } elsif ($lang eq $LANG_PHP) {
        $result = '$' . $varname . ' = ' . $source;
    }
    $result;
}


