
# return: ($lang, $bin_path, $source, $ext)
sub gent_exec {
    my ($token_ref) = @_;
    if (astlib_is_list($token_ref)) {
        genl_exec(astlib_get_list($token_ref), astlib_get_close_line_no($token_ref));
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

# return: ($lang, $bin_path, $source, $ext)
sub genl_exec {
    my ($list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($close_line_no);
    }
    if (astlib_is_list($head)) {
        my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) =
            _genl_exec_a(astlib_get_list($head), \@list, astlib_get_close_line_no($head));
        ($lang, $bin_path, $source, $ext);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($lang, $bin_path_for_sh, $source, $ext)
sub genl_exec_for_sh {
    my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) = _genl_exec_a(@_);
    ($lang, $bin_path_for_sh, $source, $ext);
}

# return: ($lang, $bin_path, $bin_path_for_sh, $source, $ext)
sub _genl_exec_a {
    my ($lang_opts_ref, $list_ref, $lang_close_line_no) = @_;
    my @lang_opts = @$lang_opts_ref;
    my $head = shift(@lang_opts);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($lang_close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my ($lang, $bin_path, $bin_path_for_sh, $ext) =
            _bin_path_to_lang(astlib_get_symbol_or_string($head));
        die create_dying_msg_unexpected($head) unless (defined($lang));
        my $source = _genl_exec_b($lang, \@lang_opts, $list_ref, $lang_close_line_no);
        ($lang, $bin_path, $bin_path_for_sh, $source, $ext);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: $source
sub genl_exec_b_for_sh {
    _genl_exec_b(@_);
}

# return: $source
sub _genl_exec_b {
    my ($lang, $lang_opts_ref, $list_ref, $lang_close_line_no) = @_;
    my @lang_opts = @$lang_opts_ref;
    my $head = shift(@lang_opts);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($lang_close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        if (astlib_get_symbol_or_string($head) =~ /\Av([1-9][0-9]*)\Z/) {
            my $ver = $1;
            _genl_exec_c($lang, $ver, \@lang_opts, $list_ref);
        } else {
            die create_dying_msg_unexpected($head);
        }
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub _genl_exec_c {
    my ($lang, $ver, $lang_opts_ref, $list_ref) = @_;
    genl_langs($list_ref, $lang, $ver);
}

my %bin_path_map = ();

# return: $bin_path, $ext
sub lang_to_bin_path {
    my ($lang) = @_;
    if ($lang eq $LANG_SH) {
        ('/bin/sh', 'sh');
    } elsif ($lang eq $LANG_PERL) {
        (_get_cmd_path('perl'), 'pl');
    } elsif ($lang eq $LANG_RUBY) {
        (_get_cmd_path('ruby'), 'rb');
    } elsif ($lang eq $LANG_PYTHON2) {
        (_get_cmd_path('python2'), 'py');
    } elsif ($lang eq $LANG_PYTHON3) {
        (_get_cmd_path('python3'), 'py');
    } else {
        die;
    }
}

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
    } elsif ($bin_path =~ /\/python2\Z/) {
        ($LANG_PYTHON2, $bin_path, $bin_path, 'py');
    } elsif ($bin_path eq 'python2') {
        ($LANG_PYTHON2, _get_cmd_path('python2'), 'python2', 'py');
    } elsif ($bin_path =~ /\/python3\Z/) {
        ($LANG_PYTHON3, $bin_path, $bin_path, 'py');
    } elsif ($bin_path eq 'python3') {
        ($LANG_PYTHON3, _get_cmd_path('python3'), 'python2', 'py');
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

