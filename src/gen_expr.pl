
sub gent_langs_expr {
    my ($token_ref, $op_order, $lang) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    die if ($lang eq $LANG_PHP);
    if (astlib_is_symbol($token_ref)) {
        astlib_get_symbol($token_ref);
    } elsif (astlib_is_string($token_ref)) {
        if ($lang eq $LANG_PERL) {
            escape_perl_string(astlib_get_string($token_ref));
        } elsif ($lang eq $LANG_RUBY) {
            escape_ruby_string(astlib_get_string($token_ref));
        } elsif ($lang eq $LANG_PYTHON2) {
            escape_python2_string(astlib_get_string($token_ref));
        } elsif ($lang eq $LANG_PYTHON3) {
            escape_python3_string(astlib_get_string($token_ref));
        } else {
            die;
        }
    } elsif (astlib_is_integer($token_ref)) {
        astlib_get_integer($token_ref);
    } elsif (astlib_is_list($token_ref)) {
        genl_langs_expr(astlib_get_list($token_ref), $op_order,
                            astlib_get_close_line_no($token_ref), $lang);
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub genl_langs_expr {
    my ($list_ref, $op_order, $close_line_no, $lang) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    die if ($lang eq $LANG_PHP);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_APPLY) {
            genl_langs_apply(\@list, $close_line_no, $lang);
        } elsif ($token eq '+' || $token eq '-') {
            genl_langs_binop($token, $OP_ORDER_PLUS, $op_order, \@list, $lang);
        } elsif ($token eq '*' || $token eq '/') {
            genl_langs_binop($token, $OP_ORDER_MULTIPLY, $op_order, \@list, $lang);
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
            } else {
                die;
            }
            genl_langs_binop($op, $op_order_plus, $op_order, \@list, $lang);
        } else {
            unshift(@list, $head);
            genl_langs_apply(\@list, $close_line_no, $lang);
        }
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_apply {
    my ($list_ref, $close_line_no, $lang) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    die if ($lang eq $LANG_PHP);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $funcname = astlib_get_symbol_or_string($head);
        genl_langs_apply_1($funcname, \@list, $lang);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_langs_apply_1 {
    my ($funcname, $list, $lang) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    die if ($lang eq $LANG_PHP);
    my $result = '';
    foreach my $elem (@$list) {
        my $source = gent_langs_argument($elem, $OP_ORDER_ARG_COMMA, $lang);
        $result = $result . ', ' if ($result);
        $result = $result . $source;
    }
    "$funcname($result)";
}

sub genl_langs_binop {
    my ($op, $op_order, $outer_op_order, $list_ref, $lang) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    die if ($lang eq $LANG_PHP);
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
        my $source = gent_langs_argument($head, $op_order, $lang);
        $result = $result . " $op " if ($result);
        $result = $result . $source;
    }
}

sub gent_langs_argument {
    my ($token_ref, $op_order, $lang) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    die if ($lang eq $LANG_PHP);
    gent_langs_expr($token_ref, $op_order, $lang);
}

