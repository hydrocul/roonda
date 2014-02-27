
# return: ($source, $istack)
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

# return: ($source, $istack)
sub genl_langs_statements {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $indent = istack_get_indent($istack);
    my $result = '';
    foreach my $elem (@$list) {
        my $source;
        ($source, $istack) = gent_langs_statement($elem, $istack, $lang, $ver);
        $result = $result . "\n" . $indent if ($result);
        $result = $result . $source;
    }
    ($result, $istack);
}

# return: ($source, $istack)
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

# return: ($source, $istack)
sub genl_langs_statement {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
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
    my $expr_source;
    if (astlib_is_symbol($head)) {
        my $symbol = astlib_get_symbol($head);
        if ($symbol eq $KEYWD_IF) {
            ($expr_source, $istack) =
                genl_langs_if(\@list, $list_close_line_no, $istack, $lang, $ver);
        } elsif ($symbol eq $KEYWD_PRINT) {
            ($expr_source, $istack) =
                genl_langs_print(\@list, $list_close_line_no, $istack, $lang, $ver);
        } elsif ($symbol eq $KEYWD_ASSIGN) {
            ($expr_source, $istack) =
                genl_langs_assign(\@list, $list_close_line_no, $istack, $lang, $ver);
        }
    }
    if (!defined($expr_source)) {
        unshift(@list, $head);
        $expr_source = genl_langs_expr(\@list, $OP_ORDER_MIN, $list_close_line_no, $istack, $lang, $ver);
    }
    if ($lang eq $LANG_PERL) {
        ($expr_source . ";", $istack);
    } elsif ($lang eq $LANG_RUBY) {
        ($expr_source, $istack);
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        ($expr_source, $istack);
    } elsif ($lang eq $LANG_PHP) {
        ($expr_source . ";", $istack);
    } else {
        die;
    }
}

# return: ($source, $istack)
sub genl_langs_if {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $cond_istack = istack_if_cond_stack($istack, $lang, $ver);
    my $then_istack = istack_if_then_else_stack($istack, $lang, $ver);
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
    my $if_indent = istack_get_indent($istack);

    my $cond_source;
    if ($lang eq $LANG_SH) {
        ($cond_source, $cond_istack)  =
            gent_sh_command($cond_elem, '', '', '', 1, '', 1, 1, $istack, $ver);
    } else {
        ($cond_source, $cond_istack) =
            gent_langs_expr($cond_elem, $OP_ORDER_MIN, $cond_istack, $lang, $ver);
    }
    my $then_source;
    ($then_source, $then_istack) =
        gent_langs_statements($then_elem, $then_istack, $lang, $ver);
    my $else_source;
    if (defined($else_elem)) {
        my $else_istack = $then_istack;
        ($else_source, $else_istack) =
            gent_langs_statements($else_elem, $else_istack, $lang, $ver);
        $istack = istack_if_result($istack, $cond_istack, $then_istack, $else_istack, $lang, $ver);
    } else {
        $istack = istack_if_result($istack, $cond_istack, $then_istack, undef, $lang, $ver);
    }
    if ($lang eq $LANG_SH) {
        if (defined($else_source)) {
            ("if $cond_source; then\n" .
             "$then_indent$then_source\n" .
             "${if_indent}else\n" .
             "$then_indent$else_source\n" .
             "${if_indent}fi",
             $istack);
        } else {
            ("if $cond_source; then\n" .
             "$then_indent$then_source\n" .
             "${if_indent}fi",
             $istack);
        }
    } elsif ($lang eq $LANG_PERL) {
        if (defined($else_source)) {
            ("if ($cond_source) {\n" .
             "$then_indent$then_source\n" .
             "$if_indent} else {\n" .
             "$then_indent$else_source\n" .
             "$if_indent}",
             $istack);
        } else {
            ("if ($cond_source) {\n" .
             "$then_indent$then_source\n" .
             "$if_indent}",
             $istack);
        }
    } elsif ($lang eq $LANG_RUBY) {
        if (defined($else_source)) {
            ("if $cond_source\n" .
             "$then_indent$then_source\n" .
             "${if_indent}else\n" .
             "$then_indent$else_source\n" .
             "${if_indent}end",
             $istack);
        } else {
            ("if $cond_source\n" .
             "$then_indent$then_source\n" .
             "${if_indent}end",
             $istack);
        }
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        if (defined($else_source)) {
            ("if $cond_source:\n" .
             "$then_indent$then_source\n" .
             "${if_indent}else:\n" .
             "$then_indent$else_source",
             $istack);
        } else {
            ("if $cond_source:\n" .
             "$then_indent$then_source",
             $istack);
        }
    } elsif ($lang eq $LANG_PHP) {
        if (defined($else_source)) {
            ("if ($cond_source) {\n" .
             "$then_indent$then_source\n" .
             "$if_indent} else {\n" .
             "$then_indent$else_source\n" .
             "$if_indent}",
             $istack);
        } else {
            ("if ($cond_source) {\n" .
             "$then_indent$then_source\n" .
             "$if_indent}",
             $istack);
        }
    } else {
        die;
    }
}

# return: ($source, $istack)
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
        ($source, $istack) = gent_langs_expr($elem, $OP_ORDER_ARG_COMMA, $istack, $lang, $ver);
    }
    if ($lang eq $LANG_SH) {
        ("echo -n $source", $istack);
    } elsif ($lang eq $LANG_PERL) {
        ("print encode('utf-8', $source)", $istack);
    } elsif ($lang eq $LANG_RUBY) {
        ("print $source", $istack);
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        ("sys.stdout.write(str($source))", $istack);
    } elsif ($lang eq $LANG_PHP) {
        ("echo $source", $istack);
    } else {
        die;
    }
}

# return: ($source, $istack)
sub genl_langs_assign {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    if (astlib_is_symbol($head)) {
        my $source;
        genl_langs_assign_1(astlib_get_symbol($head), \@list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source, $istack)
sub genl_langs_assign_1 {
    my ($varname, $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if ($lang eq $LANG_SH) {
        return (genl_sh_assign_1($varname, $list, $list_close_line_no, $istack, $ver), $istack); # TODO istack
    }
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    die create_dying_msg_unexpected(shift(@list)) if (@list);
    my $source;
    ($source, $istack) = gent_langs_expr($head, $OP_ORDER_MIN, $istack, $lang, $ver);
    my $result;
    if ($lang eq $LANG_PERL) {
        if (istack_perl_var_exists($istack, $varname)) {
            if (istack_perl_var_is_scalar($istack, $varname)) {
                $result = '$' . $varname . ' = ' . $source;
            } else {
                die; # TODO
            }
        } else {
            $result = 'my $' . $varname . ' = ' . $source;
            $istack = istack_perl_var_declare_scalar($istack, $varname);
        }
    } elsif ($lang eq $LANG_RUBY) {
        $result = $varname . ' = ' . $source;
        # TODO istack
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $result = $varname . ' = ' . $source;
        # TODO istack
    } elsif ($lang eq $LANG_PHP) {
        $result = '$' . $varname . ' = ' . $source;
        # TODO istack
    } else {
        die;
    }
    ($result, $istack);
}


