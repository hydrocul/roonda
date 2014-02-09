
# return: ($lang, $bin_path, $source, $ext)
sub gent_exec {
    my ($token) = @_;
    if (astlib_is_list($token)) {
        genl_exec(astlib_get_list($token), astlib_get_close_line_no($token));
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($lang, $bin_path, $source, $ext)
sub genl_exec {
    my ($list, $list_close_line_no) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_list($head)) {
        my $ver = 1; # TODO
        my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) =
            genl_exec_head_body(astlib_get_list($head), astlib_get_close_line_no($head),
                                \@list, $ver, 1);
        ($lang, $bin_path, $source, $ext);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($lang, $bin_path, $bin_path_for_sh, $source, $ext)
sub genl_exec_head_body {
    my ($lang_list, $lang_list_close_line_no, $list, $ver, $die_if_error) = @_;
    my @lang_list = @$lang_list;
    my $head = shift(@lang_list);
    unless (defined($head)) {
        if ($die_if_error) {
            die create_dying_msg_unexpected_closing($lang_list_close_line_no);
        } else{
            return (undef, undef, undef, undef, undef);
        }
    }
    if (astlib_is_symbol_or_string($head)) {
        my ($lang, $bin_path, $bin_path_for_sh, $ext) =
            bin_path_to_lang(astlib_get_symbol_or_string($head));
        unless (defined($lang)) {
            if ($die_if_error) {
                die create_dying_msg_unexpected($head);
            } else {
                return (undef, undef, undef, undef, undef);
            }
        }
        my $source = genl_exec_lang_head_body($lang, \@lang_list, $lang_list_close_line_no, $list);
        ($lang, $bin_path, $bin_path_for_sh, $source, $ext);
    } else {
        if ($die_if_error) {
            die create_dying_msg_unexpected($head);
        } else {
            return (undef, undef, undef, undef, undef);
        }
    }
}

# return: $source
sub genl_exec_lang_head_body {
    my ($lang, $lang_ver_list, $lang_ver_list_close_line_no, $list) = @_;
    my @lang_ver_list = @$lang_ver_list;
    my $head = shift(@lang_ver_list);
    my $ver = $roonda_spec_ver;
    if (defined($head)) {
        if (@lang_ver_list) {
            die create_dying_msg_unexpected(shift(@lang_ver_list));
        }
        if (astlib_is_symbol_or_string($head)) {
            if (astlib_get_symbol_or_string($head) =~ /\Av([1-9][0-9]*)\Z/) {
                $ver = $1;
            } else {
                die create_dying_msg_unexpected($head);
            }
        } else {
            die create_dying_msg_unexpected($head);
        }
    }
    genl_langs($list, $lang, $ver);
}

sub gent_langs {
    my ($token, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if (astlib_is_list($token)) {
        genl_langs(astlib_get_list($token), $lang, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_langs {
    my ($list, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $result = get_source_header($lang);
    foreach my $elem (@$list) {
        my $source = gent_langs_statement($elem, '', $lang, $ver);
        $result = $result . $source;
    }
    return $result;
}

