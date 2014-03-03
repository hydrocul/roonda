
# return: ($source, $istack)
sub gent_expr {
    my ($token, $op_order, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    if (astlib_is_symbol($token)) {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($token);
        }
        my $symbol = astlib_get_symbol($token);
        if ($symbol eq $KEYWD_TRUE) {
            gent_expr_boolean(1,  $istack, $lang, $ver);
        } elsif ($symbol eq $KEYWD_FALSE) {
            gent_expr_boolean('', $istack, $lang, $ver);
        } else {
            my $source;
            ($source, $istack) = gent_var_ref($symbol, $token, $istack, $lang, $ver);
            if (defined($source)) {
                return ($source, $istack);
            }
            die create_dying_msg_unexpected($token);
        }
    } elsif (astlib_is_string($token)) {
        gent_expr_string($token, $istack, $lang, $ver)
    } elsif (astlib_is_integer($token)) {
        (astlib_get_integer($token), $istack);
    } elsif (astlib_is_list($token)) {
        genl_expr(astlib_get_list($token), astlib_get_close_line_no($token),
                  $op_order, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub genl_expr {
    my ($list, $list_close_line_no, $op_order, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol($head)) {
        my $source;
        ($source, $istack) = _genl_expr_head($head, \@list, $list_close_line_no,
                                                   $op_order, $istack, $lang, $ver);
        if (defined($source)) {
            return ($source, $istack);
        }
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($head);
        }
        unshift(@list, $head);
        genl_expr_apply($list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source, $istack)
sub _genl_expr_head {
    my ($head, $list, $list_close_line_no, $op_order, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    die unless (defined($istack));
    die unless (astlib_is_symbol($head));
    my $head_symbol = astlib_get_symbol($head);
    if ($head_symbol eq $KEYWD_APPLY) {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($head);
        }
        genl_expr_apply($list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_STDIN_DATA) {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($head);
        }
        genl_expr_stdin_data($list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq '+' || $head_symbol eq '-') {
        genl_expr_binop($head_symbol, $OP_ORDER_PLUS, $op_order, '',
                         $list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq '*' || $head_symbol eq '/') {
        genl_expr_binop($head_symbol, $OP_ORDER_MULTIPLY, $op_order, '',
                         $list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq '%') {
        genl_expr_binop($head_symbol, $OP_ORDER_MULTIPLY, $op_order, 1,
                         $list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq '**') {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($head);
        }
        if ($lang eq $LANG_PERL || $lang eq $LANG_RUBY ||
            $lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
            genl_expr_binop($head_symbol, $OP_ORDER_POWER, $op_order, '',
                             $list, $list_close_line_no, $istack, $lang, $ver);
        } elsif ($lang eq $LANG_PHP) {
            genl_expr_apply_1('pow', $list, $list_close_line_no, 2, $istack, $lang, $ver);
        }
        # TODO pythonの演算子優先順位は確認済み、perl, rubyは未確認
    } elsif ($head_symbol eq $KEYWD_REF) {
        genl_var_ref($list, $list_close_line_no, $istack, $lang, $ver);
    } elsif ($head_symbol eq $KEYWD_STRCAT) {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($head);
        }
        genl_expr_strcat($op_order, $list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        (undef, $istack);
    }
}

# return: ($source, $istack)
sub gent_expr_string {
    my ($str_token, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    if ($lang eq $LANG_SH) {
        die create_dying_msg_unexpected($str_token);
    } elsif ($lang eq $LANG_PERL) {
        my $str = astlib_get_string($str_token);
        $istack = st_perl_check_string_utf8($istack, $str);
        (escape_perl_string($str), $istack);
    } elsif ($lang eq $LANG_RUBY) {
        (escape_ruby_string(astlib_get_string($str_token)), $istack);
    } elsif ($lang eq $LANG_PYTHON2) {
        (escape_python2_string(astlib_get_string($str_token)), $istack);
    } elsif ($lang eq $LANG_PYTHON3) {
        (escape_python3_string(astlib_get_string($str_token)), $istack);
    } elsif ($lang eq $LANG_PHP) {
        (escape_php_string(astlib_get_string($str_token)), $istack);
    } else {
        die;
    }
}

# return: ($source, $istack)
sub genl_expr_strcat {
    my ($op_order, $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    my $op;
    my $op_order_plus;
    if ($lang eq $LANG_PERL) {
        $op = '.';
        $op_order_plus = $OP_ORDER_PLUS;
    } elsif ($lang eq $LANG_RUBY) {
        $op = '+';
        $op_order_plus = $OP_ORDER_PLUS;
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $op = '+';
        $op_order_plus = $OP_ORDER_PLUS;
    } elsif ($lang eq $LANG_PHP) {
        $op = '.';
        $op_order_plus = $OP_ORDER_PLUS;
    } else {
        die;
    }
    genl_expr_binop($op, $op_order_plus, $op_order, '',
                     $list, $list_close_line_no, $istack, $lang, $ver);
}

# return: ($source, $istack)
sub genl_expr_apply {
    my ($list, $close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $funcname = astlib_get_symbol_or_string($head);
        genl_expr_apply_1($funcname, \@list, $close_line_no, -1, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source, $istack)
sub genl_expr_apply_1 {
    my ($funcname, $list, $list_close_line_no, $args_count, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my @list = @$list;
    if ($args_count >= 0 && (scalar @list) > $args_count) {
        die create_dying_msg_unexpected($list[$args_count]);
    }
    if ($args_count >= 0 && (scalar @list) < $args_count) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $result = '';
    foreach my $elem (@list) {
        my $child_istack = st_expr_child($istack);
        my $source;
        ($source, $child_istack) = gent_expr($elem, $OP_ORDER_ARG_COMMA, $child_istack, $lang, $ver);
        $istack = st_expr_parent($istack, $child_istack);
        $result = $result . ', ' if ($result);
        $result = $result . $source;
    }
    ("$funcname($result)", $istack);
}

# return: ($source, $istack)
sub genl_expr_stdin_data {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (@list) {
        die create_dying_msg_unexpected(shift(@list));
    }
    if (astlib_is_symbol_or_string($head)) {
        my $format_from = astlib_get_symbol_or_string($head);
        if ($lang eq $LANG_PERL) {
            $istack = st_perl_set_needs_use_utf8($istack);
        }
        (gent_embed_simple_obj($format_from, $lang, $ver), $istack);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source, $istack)
sub genl_expr_binop {
    my ($op, $op_order, $outer_op_order, $is_bin_only,
        $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    my @list = @$list;
    if ($is_bin_only) {
        die create_dying_msg_unexpected_closing($list_close_line_no) if ((scalar @list) == 0);
        die create_dying_msg_unexpected_closing($list_close_line_no) if ((scalar @list) == 1);
        die create_dying_msg_unexpected($list[2]) if ((scalar @list) > 2);
    }
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            if ($op_order <= $outer_op_order) {
                if ($lang eq $LANG_SH) {
                    return ("\( $result \)", $istack);
                } else {
                    return ("($result)", $istack);
                }
            } else {
                return ($result, $istack);
            }
        }
        my $child_istack = st_expr_child($istack);
        my $source;
        ($source, $child_istack) = gent_expr($head, $op_order, $child_istack, $lang, $ver);
        $istack = st_expr_parent($istack, $child_istack);
        if ($result) {
            if ($lang eq $LANG_SH) {
                $result = $result . ' ' . escape_sh_string($op) . ' ';
            } else {
                $result = $result . " $op ";
            }
        }
        $result = $result . $source;
    }
}

# return: ($source, $istack)
sub gent_expr_boolean {
    my ($boolValue, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    if ($lang eq $LANG_PERL) {
        if ($boolValue) {
            ('1', $istack);
        } else {
            ("''", $istack);
        }
    } elsif ($lang eq $LANG_RUBY) {
        if ($boolValue) {
            ('true', $istack);
        } else {
            ('false', $istack);
        }
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        if ($boolValue) {
            ('True', $istack);
        } else {
            ('False', $istack);
        }
    } elsif ($lang eq $LANG_PHP) {
        if ($boolValue) {
            ('TRUE', $istack);
        } else {
            ('FALSE', $istack);
        }
    } else {
        die;
    }
}

sub st_expr_child {
    my ($parent_istack) = @_;
    $parent_istack;
}

sub st_expr_parent {
    my ($parent_istack, $child_istack) = @_;
    my $lang = $parent_istack->{lang};
    die if ($lang ne $child_istack->{lang});
    if ($lang eq $LANG_PERL) {
        $parent_istack = st_perl_report_use_utf8($parent_istack, $child_istack);
    }
    $parent_istack;
}


