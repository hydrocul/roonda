
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

# return: ($bin_path_for_sh, $source, $ext)
sub genl_exec_for_sh {
    my ($lang_opts_ref, $list_ref, $lang_close_line_no, $ver) = @_;
    my @lang_opts = @$lang_opts_ref;
    my $head = shift(@lang_opts);
    unless (defined($head)) {
        return (undef, undef, undef)
    }
    if (astlib_is_symbol_or_string($head)) {
        my ($lang, $bin_path, $bin_path_for_sh, $ext) =
            bin_path_to_lang(astlib_get_symbol_or_string($head));
        return (undef, undef, undef) unless (defined($lang));
        my $source = _genl_exec_c($lang, $ver, \@lang_opts, $list_ref);
        ($bin_path_for_sh, $source, $ext);
    } else {
        (undef, undef, undef);
    }
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
            bin_path_to_lang(astlib_get_symbol_or_string($head));
        die create_dying_msg_unexpected($head) unless (defined($lang));
        my $source = _genl_exec_b($lang, \@lang_opts, $list_ref, $lang_close_line_no);
        ($lang, $bin_path, $bin_path_for_sh, $source, $ext);
    } else {
        die create_dying_msg_unexpected($head);
    }
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

# return: $source
sub genl_exec_c_for_sh {
    _genl_exec_c(@_);
}

sub _genl_exec_c {
    my ($lang, $ver, $lang_opts_ref, $list_ref) = @_;
    genl_langs($list_ref, $lang, $ver);
}

