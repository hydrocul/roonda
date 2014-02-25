
sub gent_langs_expr {
    my ($token, $op_order, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    if (astlib_is_symbol($token)) {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($token);
        }
        my $symbol = astlib_get_symbol($token);
        if ($symbol eq $KEYWD_TRUE) {
            gent_langs_boolean(1, $lang, $ver);
        } elsif ($symbol eq $KEYWD_FALSE) {
            gent_langs_boolean('', $lang, $ver);
        } else {
            die create_dying_msg_unexpected($token);
        }
    } elsif (astlib_is_string($token)) {
        if ($lang eq $LANG_SH) {
            die create_dying_msg_unexpected($token);
        } elsif ($lang eq $LANG_PERL) {
            escape_perl_string(astlib_get_string($token));
        } elsif ($lang eq $LANG_RUBY) {
            escape_ruby_string(astlib_get_string($token));
        } elsif ($lang eq $LANG_PYTHON2) {
            escape_python2_string(astlib_get_string($token));
        } elsif ($lang eq $LANG_PYTHON3) {
            escape_python3_string(astlib_get_string($token));
        } elsif ($lang eq $LANG_PHP) {
            escape_php_string(astlib_get_string($token));
        } else {
            die "Died: $lang";
        }
    } elsif (astlib_is_integer($token)) {
        astlib_get_integer($token);
    } elsif (astlib_is_list($token)) {
        genl_langs_expr(astlib_get_list($token), $op_order,
                        astlib_get_close_line_no($token), $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs_expr {
    my ($list, $op_order, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    # LANG_SH では expr コマンドのパラメータとして計算式を組み立てる
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $symbol = astlib_get_symbol_or_string($head);
        if ($symbol eq $KEYWD_APPLY) {
            if ($lang eq $LANG_SH) {
                die create_dying_msg_unexpected($head);
            }
            genl_langs_apply(\@list, $list_close_line_no, $lang, $ver);
        } elsif ($symbol eq $KEYWD_STDIN_DATA) {
            if ($lang eq $LANG_SH) {
                die create_dying_msg_unexpected($head);
            }
            genl_langs_stdin_data(\@list, $list_close_line_no, $lang, $ver);
        } elsif ($symbol eq '+' || $symbol eq '-') {
            genl_langs_binop($symbol, $OP_ORDER_PLUS, $op_order, '',
                             \@list, $list_close_line_no, $lang, $ver);
        } elsif ($symbol eq '*' || $symbol eq '/') {
            genl_langs_binop($symbol, $OP_ORDER_MULTIPLY, $op_order, '',
                             \@list, $list_close_line_no, $lang, $ver);
        } elsif ($symbol eq '%') {
            genl_langs_binop($symbol, $OP_ORDER_MULTIPLY, $op_order, 1,
                             \@list, $list_close_line_no, $lang, $ver);
        } elsif ($symbol eq '**') {
            if ($lang eq $LANG_SH) {
                die create_dying_msg_unexpected($head);
            }
            if ($lang eq $LANG_PERL || $lang eq $LANG_RUBY ||
                $lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
                genl_langs_binop($symbol, $OP_ORDER_POWER, $op_order, '',
                                 \@list, $list_close_line_no, $lang, $ver);
            } elsif ($lang eq $LANG_PHP) {
                genl_langs_apply_1('pow', \@list, $list_close_line_no, 2, $lang, $ver);
            }
            # TODO pythonの演算子優先順位は確認済み、perl, rubyは未確認
        } elsif ($symbol eq $KEYWD_REF) {
            genl_langs_ref(\@list, $list_close_line_no, $istack, $lang, $ver);
        } elsif ($symbol eq $KEYWD_STRCAT) {
            if ($lang eq $LANG_SH) {
                die create_dying_msg_unexpected($head);
            }
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
            genl_langs_binop($op, $op_order_plus, $op_order, '',
                             \@list, $list_close_line_no, $lang, $ver);
        } else {
            if ($lang eq $LANG_SH) {
                die create_dying_msg_unexpected($head);
            }
            unshift(@list, $head);
            genl_langs_apply(\@list, $list_close_line_no, $lang, $ver);
        }
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_apply {
    my ($list, $close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $funcname = astlib_get_symbol_or_string($head);
        genl_langs_apply_1($funcname, \@list, $close_line_no, -1, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_apply_1 {
    my ($funcname, $list, $list_close_line_no, $args_count, $lang, $ver) = @_;
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
        my $source = gent_langs_argument($elem, $OP_ORDER_ARG_COMMA, $lang, $ver);
        $result = $result . ', ' if ($result);
        $result = $result . $source;
    }
    "$funcname($result)";
}

sub genl_langs_stdin_data {
    my ($list, $list_close_line_no, $lang, $ver) = @_;
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
        gent_embed_simple_obj($format_from, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_binop {
    my ($op, $op_order, $outer_op_order, $is_bin_only, $list, $list_close_line_no, $lang, $ver) = @_;
    my $istack = istack_create(); # TODO istack
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
                    return "\( $result \)";
                } else {
                    return "($result)";
                }
            } else {
                return $result;
            }
        }
        my $source = gent_langs_expr($head, $op_order, $istack, $lang, $ver);
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

sub gent_langs_argument {
    my ($token, $op_order, $lang, $ver) = @_;
    my $istack = istack_create(); # TODO istack
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    gent_langs_expr($token, $op_order, $istack, $lang, $ver);
}

sub gent_langs_boolean {
    my ($boolValue, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    if ($lang eq $LANG_PERL) {
        if ($boolValue) {
            '1';
        } else {
            "''";
        }
    } elsif ($lang eq $LANG_RUBY) {
        if ($boolValue) {
            'true'
        } else {
            'false'
        }
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        if ($boolValue) {
            'True'
        } else {
            'False'
        }
    } elsif ($lang eq $LANG_PHP) {
        if ($boolValue) {
            'TRUE'
        } else {
            'FALSE'
        }
    } else {
        die;
    }
}

sub genl_langs_ref {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol($head)) {
        if (@list) {
            die create_dying_msg_unexpected(shift(@list));
        }
        my $varname = astlib_get_symbol($head);
        genl_langs_ref_varname($varname, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_ref_varname {
    my ($varname, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang ne $LANG_SH && $ver < 2);
    if ($lang eq $LANG_SH) {
        '$' . $varname;
    } elsif ($lang eq $LANG_PERL) {
        '$' . $varname;
    } elsif ($lang eq $LANG_RUBY) {
        $varname;
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $varname;
    } elsif ($lang eq $LANG_PHP) {
        '$' . $varname;
    } else {
        die;
    }
}

