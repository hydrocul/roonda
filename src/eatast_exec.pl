
sub eat_token_exec {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_exec($token, $line_no_2);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_exec {
    my ($list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die "Unexpected token: `)` (Line: $close_line_no)";
    }
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$head;
    if ($type eq $TOKEN_TYPE_LIST) {
        my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) = _eat_list_exec_a($token, \@list, $line_no_2);
        ($lang, $bin_path, $source, $ext);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_exec_for_sh {
    my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) = _eat_list_exec_a(@_);
    ($lang, $bin_path_for_sh, $source, $ext);
}

sub _eat_list_exec_a {
    my ($lang_opts_ref, $list_ref, $lang_close_line_no) = @_;
    my @lang_opts = @$lang_opts_ref;
    my $head = shift(@lang_opts);
    unless (defined($head)) {
        die "Unexpected token: `)` (Line: $lang_close_line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        my ($lang, $bin_path, $bin_path_for_sh, $ext) = _bin_path_to_lang($token);
        die "Unexpected token: `$token_str` (Line: $line_no)" unless (defined($lang));
        my $source = _eat_list_exec_b($lang, \@lang_opts, $list_ref);
        ($lang, $bin_path, $bin_path_for_sh, $source, $ext);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub _eat_list_exec_b {
    my ($lang, $lang_opts_ref, $list_ref) = @_;
    eat_list_langs($list_ref, $lang);
}

my %bin_path_map = ();

sub _bin_path_to_lang {
    my ($bin_path) = @_;
    if ($bin_path =~ /\/sh\Z/) {
        ($LANG_SH, $bin_path, $bin_path, 'sh');
    } elsif ($bin_path eq 'sh') {
        ($LANG_SH, '/bin/sh', 'sh', 'sh');
    } elsif ($bin_path =~ /\/perl\Z/) {
        ($LANG_PERL, $bin_path, $bin_path, 'pl');
    } elsif ($bin_path eq 'perl') {
        ($LANG_PERL, _get_cmd_path('perl'), 'perl', 'pl');
    } elsif ($bin_path =~ /\/ruby\Z/) {
        ($LANG_RUBY, $bin_path, $bin_path, 'rb');
    } elsif ($bin_path eq 'ruby') {
        ($LANG_RUBY, _get_cmd_path('ruby'), 'ruby', 'rb');
    } else {
        (undef, undef, undef, undef);
    }
}

sub _get_cmd_path {
    my ($cmd) = @_;
    if (defined($bin_path_map{$cmd})) {
        return $bin_path_map{$cmd};
    }
    my $path = `sh -c "which $cmd"`;
    $path =~ s/\A(.*)\s*\Z/$1/;
    unless ($path) {
        die "Command not found: $cmd";
    }
    $bin_path_map{$cmd} = $path;
    $path;
}

