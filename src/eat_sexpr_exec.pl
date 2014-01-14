
sub eat_token_exec {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_exec($token, $line_no);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_exec {
    my ($list_ref, $list_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected empty list (Line: $list_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_exec_0($token, \@list, $line_no);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_exec_0 {
    my ($lang_ref, $list_ref, $list_line_no) = @_;
    my @lang = @$lang_ref;
    my $head = shift(@lang);
    unless (defined($head)) {
        die "Unexpected empty list (Line: $list_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token =~ /\/sh\Z/) {
            eat_list_exec_sh($token, \@lang, $list_ref);
        } elsif ($token eq 'sh') {
            eat_list_exec_sh(undef, \@lang, $list_ref);
        } elsif ($token =~ /\/perl\Z/) {
            eat_list_exec_perl($token, \@lang, $list_ref);
        } elsif ($token eq 'perl') {
            eat_list_exec_perl(undef, \@lang, $list_ref);
        } else {
            die "Unexpected token: `$token_str` (Line: $line_no)";
        }
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

