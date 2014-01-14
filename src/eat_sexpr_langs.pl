
sub eat_token_langs {
    my ($token_ref, $lang) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_langs($token, $lang);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_langs {
    my ($list_ref, $lang) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_langs_statement($head, $lang);
        $result = $result . $source . "\n";
    }
}

sub eat_token_langs_statement {
    my ($token_ref, $lang) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_langs_statement($token, $line_no, $lang);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_token_langs_expr {
    my ($token_ref, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL) {
        $token;
    } elsif ($type eq $TOKEN_TYPE_STRING) {
        if ($lang eq $LANG_PERL) {
            escape_perl_string($token);
        } else {
            die;
        }
    } elsif ($type eq $TOKEN_TYPE_INTEGER) {
        $token;
    } elsif ($type eq $TOKEN_TYPE_LIST) {
        eat_list_langs_expr($token, $line_no, $lang);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_langs_expr {
    my ($list_ref, $list_line_no, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected empty list (Line: $list_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'apply') {
            eat_list_langs_apply(\@list, $list_line_no, $lang);
        } elsif ($token eq '+' || $token eq '-') {
            eat_list_langs_binop($token, \@list, $lang);
        } else {
            unshift(@list, $head);
            eat_list_langs_apply(\@list, $list_line_no, $lang);
        }
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_langs_statement {
    my ($list_ref, $list_line_no, $lang) = @_;
    if ($lang eq $LANG_SH) {
        return eat_list_sh_statement($list_ref);
    }
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected empty list (Line: $list_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'if') {
            die "TODO";
        } else {
            unshift(@list, $head);
            eat_list_langs_expr(\@list, $list_line_no, $lang) . ';';
        }
    } else {
        unshift(@list, $head);
        eat_list_langs_expr(\@list, $list_line_no, $lang) . ';';
    }
}

sub eat_list_langs_apply {
    my ($list_ref, $list_line_no, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected empty list (Line: $list_line_no)";
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
        my $source = eat_token_langs_argument($head, $lang);
        $result = $result . ', ' if ($result);
        $result = $result . $source;
    }
    "$funcname($result)";
}

sub eat_list_langs_binop {
    my ($op, $list_ref, $lang) = @_;
    die if ($lang eq $LANG_SH);
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_langs_argument($head, $lang);
        $result = $result . " $op " if ($result);
        $result = $result . $source;
    }
}

sub eat_token_langs_argument {
    my ($token_ref, $lang) = @_;
    die if ($lang eq $LANG_SH);
    eat_token_langs_expr($token_ref, $lang);
}

