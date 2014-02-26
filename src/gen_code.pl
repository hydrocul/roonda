
# return: ($lang, $bin_path, $source_head, $source_body, $ext)
sub gent_exec {
    my ($token, $ver) = @_;
    if (astlib_is_list($token)) {
        my ($lang, $bin_path, $bin_path_for_sh, $source_head, $source_body, $ext) =
            genl_exec(astlib_get_list($token), astlib_get_close_line_no($token), $ver);
        ($lang, $bin_path, $source_head, $source_body, $ext);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($lang, $bin_path, $bin_path_for_sh, $source_head, $source_body, $ext)
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
        if ($ver < 2 && $lang ne $LANG_SH) {
            die "Unsupported language: $lang";
        }
        my ($source_head, $source_body) = genl_exec_lang(\@list, $list_close_line_no, $lang, $ver);
        my ($lang_, $bin_path, $bin_path_for_sh, $ext) = bin_path_to_lang($lang);
        ($lang, $bin_path, $bin_path_for_sh, $source_head, $source_body, $ext);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source_head, $source_body)
sub genl_exec_lang {
    my ($list, $list_close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $head = shift(@list);
    if (astlib_is_symbol($head)) {
        my $symbol = astlib_get_symbol($head);
        if ($symbol =~ /\Av([1-9][0-9]*)\z/) {
            $ver = $1;
            if ($ver > $MAX_VERSION) {
                die "Unknown version: $ver";
            }
            if ($ver == $MAX_VERSION && !$is_experimental) {
                die "version $ver is experimental";
            }
        } else {
            unshift(@list, $head);
        }
    } else {
        unshift(@list, $head);
    }
    die "Unspecified version" if $ver < 1;
    genl_exec_lang_ver(\@list, $list_close_line_no, $lang, $ver);
}

# return: ($source_head, $source_body)
sub genl_exec_lang_ver {
    my ($list, $list_close_line_no, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my $result_head = get_source_header($lang, $ver);
    my $istack = istack_create($lang, $ver);
    my $result;
    ($result, $istack) = genl_langs_statements($list, $list_close_line_no, $istack, $lang, $ver);
    $result = $result . "\n";
    if ($lang eq $LANG_PERL) {
        if (istack_perl_needs_use_utf8($istack)) {
            $result = "use utf8;\n\n" . $result;
        }
    }
    ($result_head, $result);
}

