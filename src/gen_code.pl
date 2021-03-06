
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
        if (!defined($lang)) {
            die create_dying_msg_unexpected($head);
        }
        if ($lang eq $LANG_SEXPR) {
            die create_dying_msg_unexpected($head);
        }
        my ($source_head, $source_body) = genl_exec_lang(\@list, $list_close_line_no, $lang, $ver);
        my ($bin_path, $bin_path_for_sh, $ext) = lang_to_bin_path($lang);
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
    if (!defined($head)) {
        # nop
    } elsif (astlib_is_symbol($head)) {
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
    if (!is_lang_support($lang, $ver)) {
        die "Unsupported language: $lang";
    }
    my $result_head = get_source_header($lang, $ver);
    my $istack = istack_create($lang, $ver);
    my $result;
    ($result, $istack) = genl_stmt_statements($list, $list_close_line_no, $istack, $lang, $ver);
    $result = $result . "\n";
    if ($lang eq $LANG_PERL) {
        if (st_perl_needs_use_utf8($istack)) {
            $result = "use utf8;\n\n" . $result;
        }
    }
    ($result_head, $result);
}

