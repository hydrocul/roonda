
sub gent_langs_expr {
    my ($token, $op_order, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    if (astlib_is_symbol($token)) {
        die create_dying_msg_unexpected($token);
    } elsif (astlib_is_string($token)) {
        if ($lang eq $LANG_PERL) {
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
            die;
        }
    } elsif (astlib_is_integer($token)) {
        astlib_get_integer($token);
    } elsif (astlib_is_list($token)) {
        genl_langs_expr(astlib_get_list($token), $op_order,
                        astlib_get_close_line_no($token), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs_expr {
    my ($list, $op_order, $close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_APPLY) {
            genl_langs_apply(\@list, $close_line_no, $lang, $ver);
        } elsif ($token eq $KEYWD_STDIN_DATA) {
            genl_langs_stdin_data(\@list, $close_line_no, $lang, $ver);
        } elsif ($token eq '+' || $token eq '-') {
            genl_langs_binop($token, $OP_ORDER_PLUS, $op_order, \@list, $lang, $ver);
        } elsif ($token eq '*' || $token eq '/') {
            genl_langs_binop($token, $OP_ORDER_MULTIPLY, $op_order, \@list, $lang, $ver);
        } elsif ($token eq $KEYWD_STRCAT) {
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
            genl_langs_binop($op, $op_order_plus, $op_order, \@list, $lang, $ver);
        } else {
            unshift(@list, $head);
            genl_langs_apply(\@list, $close_line_no, $lang, $ver);
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
        genl_langs_apply_1($funcname, \@list, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_apply_1 {
    my ($funcname, $list, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my $result = '';
    foreach my $elem (@$list) {
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
    my ($op, $op_order, $outer_op_order, $list, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my @list = @$list;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            if ($op_order <= $outer_op_order) {
                return "($result)";
            } else {
                return $result;
            }
        }
        my $source = gent_langs_argument($head, $op_order, $lang, $ver);
        $result = $result . " $op " if ($result);
        $result = $result . $source;
    }
}

sub gent_langs_argument {
    my ($token, $op_order, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    gent_langs_expr($token, $op_order, $lang, $ver);
}

