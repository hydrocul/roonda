
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
        my ($lang, $bin_path) = bin_path_to_lang($token);
        die "Unexpected token: `$token_str` (Line: $line_no)" unless (defined($lang));
        my $source = eat_list_langs($list_ref, $lang);
        ($bin_path, $source);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub bin_path_to_lang {
    my ($bin_path) = @_;
    if ($bin_path =~ /\/sh\Z/) {
        ($LANG_SH, $bin_path);
    } elsif ($bin_path eq 'sh') {
        ($LANG_SH, '/bin/sh');
    } elsif ($bin_path =~ /\/perl\Z/) {
        ($LANG_PERL, $bin_path);
    } elsif ($bin_path eq 'perl') {
        ($LANG_PERL, '/usr/bin/perl');
    } else {
        (undef, undef);
    }
}

