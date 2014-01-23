
sub eat_token_langs {
    my ($token_ref, $lang, $ver) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_langs($token, $lang, $ver);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
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
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_langs_statement($token, $line_no_2, $lang, $ver);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
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
        die "Unexpected token: `)` (Line: $close_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    my $expr_source;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'if') {
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
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL) {
        $token;
    } elsif ($type eq $TOKEN_TYPE_STRING) {
        if ($lang eq $LANG_PERL) {
            escape_perl_string($token);
        } elsif ($lang eq $LANG_RUBY) {
            escape_ruby_string($token);
        } else {
            die;
        }
    } elsif ($type eq $TOKEN_TYPE_INTEGER) {
        $token;
    } elsif ($type eq $TOKEN_TYPE_LIST) {
        eat_list_langs_expr($token, $op_order, $line_no_2, $lang);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_langs_expr {
    my ($list_ref, $op_order, $close_line_no, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected token: `)` (Line: $close_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'apply') {
            eat_list_langs_apply(\@list, $close_line_no, $lang);
        } elsif ($token eq '+' || $token eq '-') {
            eat_list_langs_binop($token, $OP_ORDER_PLUS, $op_order, \@list, $lang);
        } elsif ($token eq '*' || $token eq '/') {
            eat_list_langs_binop($token, $OP_ORDER_MULTIPLY, $op_order, \@list, $lang);
        } elsif ($token eq 'strcat') {
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
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_langs_apply {
    my ($list_ref, $close_line_no, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected token: `)` (Line: $close_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        my $funcname = $token;
        eat_list_langs_apply_1($funcname, \@list, $lang);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_langs_apply_1 {
    my ($funcname, $list_ref, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            last;
        }
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

