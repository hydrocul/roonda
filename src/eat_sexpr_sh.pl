
sub eat_list_exec_sh {
    my ($bin_path, $lang_opts_ref, $list_ref) = @_;
    unless (defined($bin_path)) {
        $bin_path = '/bin/sh';
    }
    ($bin_path, eat_list_sh($list_ref));
}

sub eat_token_sh {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_sh($token);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_sh {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_sh_statement($head);
        $result = $result . $source . "\n";
    }
}

sub eat_token_sh_statement {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_sh_statement($token);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
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
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

