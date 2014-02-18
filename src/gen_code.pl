
# return: ($lang, $bin_path, $source, $ext)
sub gent_exec {
    my ($token, $ver) = @_;
    if (astlib_is_list($token)) {
        my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) =
            genl_exec(astlib_get_list($token), astlib_get_close_line_no($token), $ver);
        ($lang, $bin_path, $source, $ext);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($lang, $bin_path, $bin_path_for_sh, $source, $ext)
sub genl_exec {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol($head)) {
        my $symbol = astlib_get_symbol($head);
        my $lang = get_dst_format_label($symbol);
        if (!defined($lang) || $lang eq $LANG_SEXPR) {
            die create_dying_msg_unexpected($head);
        }
        my $source = genl_exec_lang(\@list, $list_close_line_no, $lang, $ver);
        my ($lang_, $bin_path, $bin_path_for_sh, $ext) = bin_path_to_lang($lang);
        ($lang, $bin_path, $bin_path_for_sh, $source, $ext);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: $source
sub genl_exec_lang {
    my ($list, $list_close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $head = shift(@list);
    if (astlib_is_symbol($head)) {
        my $symbol = astlib_get_symbol($head);
        if ($symbol =~ /\Av([1-9][0-9]*)\z/) {
            $ver = $1;
        } else {
            unshift(@list, $head);
        }
    } else {
        unshift(@list, $head);
    }
    genl_exec_lang_ver(\@list, $list_close_line_no, $lang, $ver);
}

sub genl_exec_lang_ver {
    my ($list, $list_close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $result = get_source_header($lang, $ver);
    $result = $result . genl_langs_statements($list, $list_close_line_no, '', $lang, $ver);
    $result = $result . "\n";
    $result;
}

