
sub eat_list_exec_sh {
    my ($bin_path, $lang_opts_ref, $list_ref) = @_;
    unless (defined($bin_path)) {
        $bin_path = '/bin/sh';
    }
    ($bin_path, eat_list_langs($list_ref, $LANG_SH));
}

sub eat_list_sh_statement {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_sh_argument($head);
        $result = $result . ' ' if ($result);
        $result = $result . $source;
    }
}

sub eat_token_sh_argument {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING || $type eq $TOKEN_TYPE_INTEGER) {
        escape_sh_string($token);
    } elsif ($type eq $TOKEN_TYPE_LIST) {
        eat_list_sh_argument($token);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_sh_argument {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        return "''";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'backticks') {
            eat_list_sh_argument_backticks(\@list);
        } else {
            die "Unexpected token: `$token_str` (Line: $line_no)";
        }
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_sh_argument_backticks {
    my ($list_ref) = @_;
    my $source = eat_list_sh_statement($list_ref);
    escape_sh_backticks($source);
}

