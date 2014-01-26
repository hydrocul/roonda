
sub eat_token_langs {
    my ($token_ref, $lang, $ver) = @_;
    if (astlib_is_list($token_ref)) {
        eat_list_langs(astlib_get_list($token_ref), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub eat_list_langs {
    my ($list_ref, $lang, $ver) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_langs_statement($head, $lang, $ver);
        $result = $result . $source . "\n";
    }
}

sub eat_token_langs_statement {
    my ($token_ref, $lang, $ver) = @_;
    if (astlib_is_list($token_ref)) {
        eat_list_langs_statement(astlib_get_list($token_ref), astlib_get_close_line_no($token_ref), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub eat_list_langs_statement {
    my ($list_ref, $close_line_no, $lang, $ver) = @_;
    if ($lang eq $LANG_SH) {
        return eat_list_sh_statement($list_ref, $close_line_no, $ver);
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
            $expr_source = eat_list_langs_expr(\@list, $OP_ORDER_MIN, $close_line_no, $lang);
        }
    } else {
        unshift(@list, $head);
        $expr_source = eat_list_langs_expr(\@list, $OP_ORDER_MIN, $close_line_no, $lang);
    }
    if ($lang eq $LANG_PERL) {
        $expr_source . ';';
    } elsif ($lang eq $LANG_RUBY) {
        $expr_source;
    } else {
        die;
    }
}

sub eat_token_langs_expr {
    my ($token_ref, $op_order, $lang) = @_;
    die if ($lang eq $LANG_SH);
    if (astlib_is_symbol($token_ref)) {
        astlib_get_symbol($token_ref);
    } elsif (astlib_is_string($token_ref)) {
        if ($lang eq $LANG_PERL) {
            escape_perl_string(astlib_get_string($token_ref));
        } elsif ($lang eq $LANG_RUBY) {
            escape_ruby_string(astlib_get_string($token_ref));
        } else {
            die;
        }
    } elsif (astlib_is_integer($token_ref)) {
        astlib_get_integer($token_ref);
    } elsif (astlib_is_list($token_ref)) {
        eat_list_langs_expr(astlib_get_list($token_ref), $op_order,
                            astlib_get_close_line_no($token_ref), $lang);
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub eat_list_langs_expr {
    my ($list_ref, $op_order, $close_line_no, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_APPLY) {
            eat_list_langs_apply(\@list, $close_line_no, $lang);
        } elsif ($token eq '+' || $token eq '-') {
            eat_list_langs_binop($token, $OP_ORDER_PLUS, $op_order, \@list, $lang);
        } elsif ($token eq '*' || $token eq '/') {
            eat_list_langs_binop($token, $OP_ORDER_MULTIPLY, $op_order, \@list, $lang);
        } elsif ($token eq $KEYWD_STRCAT) {
            my $op;
            my $op_order_plus;
            if ($lang eq $LANG_PERL) {
                $op = '.';
                $op_order_plus = $OP_ORDER_PLUS;
            } elsif ($lang eq $LANG_RUBY) {
                $op = '+';
                $op_order_plus = $OP_ORDER_PLUS;
            } else {
                die;
            }
            eat_list_langs_binop($op, $op_order_plus, $op_order, \@list, $lang);
        } else {
            unshift(@list, $head);
            eat_list_langs_apply(\@list, $close_line_no, $lang);
        }
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub eat_list_langs_apply {
    my ($list_ref, $close_line_no, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $funcname = astlib_get_symbol_or_string($head);
        eat_list_langs_apply_1($funcname, \@list, $lang);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub eat_list_langs_apply_1 {
    my ($funcname, $list_ref, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        last unless (defined($head));
        my $source = eat_token_langs_argument($head, $OP_ORDER_ARG_COMMA, $lang);
        $result = $result . ', ' if ($result);
        $result = $result . $source;
    }
    "$funcname($result)";
}

sub eat_list_langs_binop {
    my ($op, $op_order, $outer_op_order, $list_ref, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
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
        my $source = eat_token_langs_argument($head, $op_order, $lang);
        $result = $result . " $op " if ($result);
        $result = $result . $source;
    }
}

sub eat_token_langs_argument {
    my ($token_ref, $op_order, $lang) = @_;
    die if ($lang eq $LANG_SH);
    eat_token_langs_expr($token_ref, $op_order, $lang);
}

