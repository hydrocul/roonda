
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
        eat_list_exec_a($token, \@list, $line_no);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_exec_a {
    my ($lang_opts_ref, $list_ref, $lang_list_line_no) = @_;
    my @lang_opts = @$lang_opts_ref;
    my $head = shift(@lang_opts);
    unless (defined($head)) {
        die "Unexpected empty list (Line: $lang_list_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        my ($lang, $bin_path, $ext) = bin_path_to_lang($token);
        die "Unexpected token: `$token_str` (Line: $line_no)" unless (defined($lang));
        my $source = eat_list_exec_b($lang, \@lang_opts, $list_ref);
        ($bin_path, $source, $ext);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_exec_b {
    my ($lang, $lang_opts_ref, $list_ref) = @_;
    eat_list_langs($list_ref, $lang);
}

sub bin_path_to_lang {
    my ($bin_path) = @_;
    if ($bin_path =~ /\/sh\Z/) {
        ($LANG_SH, $bin_path, 'sh');
    } elsif ($bin_path eq 'sh') {
        ($LANG_SH, '/bin/sh', 'sh');
    } elsif ($bin_path =~ /\/perl\Z/) {
        ($LANG_PERL, $bin_path, 'pl');
    } elsif ($bin_path eq 'perl') {
        ($LANG_PERL, '/usr/bin/perl', 'pl');
    } else {
        (undef, undef, undef);
    }
}

