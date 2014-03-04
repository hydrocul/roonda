
# return: ($source, $istack)
sub genl_function {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    # TODO python以外でのfunction
    my @list = @$list;
    my $funcname_token = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($funcname_token));
    if (astlib_is_symbol($funcname_token)) {
        my $funcname = astlib_get_symbol($funcname_token);
        genl_function_1($funcname, \@list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($funcname_token);
    }
}

# return: ($source, $istack)
sub genl_function_1 {
    my ($funcname, $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    # TODO python以外でのfunction
    my @list = @$list;
    my $args_token = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($args_token));
    my $args_istack = st_function_args_stack($istack, $lang, $ver);
    my $args_source;
    ($args_source, $args_istack) = gent_function_args($args_token, $args_istack, $lang, $ver);
    genl_function_2($funcname, $args_source, \@list, $list_close_line_no, $istack, $args_istack, $lang, $ver);
}

# return: ($source, $istack)
sub genl_function_2 {
    my ($funcname, $args_source, $list, $list_close_line_no, $parent_istack, $args_istack, $lang, $ver) = @_;
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    # TODO python以外でのfunction
    my $body_istack = st_function_body_stack($parent_istack, $args_istack, $lang, $ver);
    my $body_source;
    ($body_source, $body_istack) = genl_stmt_statements($list, $list_close_line_no, $body_istack, $lang, $ver);
    my $indent = istack_get_indent($parent_istack);
    my $body_indent = istack_get_indent($body_istack);
    my $source = _gent_function_sub($funcname, $args_source, $body_source, $indent, $body_indent, $lang, $ver);
    my $istack = st_function_result($parent_istack, $body_istack, $lang, $ver);
    ($source, $istack);
}

# return: ($source, $istack)
sub gent_function_args {
    my ($token, $istack, $lang, $ver) = @_;
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    # TODO python以外でのfunction
    if (astlib_is_list($token)) {
        my @list = @{astlib_get_list($token)};
        my $result = '';
        foreach my $elem (@list) {
            unless (astlib_is_symbol($elem)) {
                die create_dying_msg_unexpected($elem);
            }
            my $source;
            ($source, $istack) = gent_function_arg($elem, $istack, $lang, $ver);
            $result = $result . ', ' if ($result);
            $result = $result . $source;
        }
        ("($result)", $istack);
    } elsif (astlib_is_symbol($token)) {
        my $source;
        ($source, $istack) = gent_function_arg($token, $istack, $lang, $ver);
        ("($source)", $istack);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub gent_function_arg {
    my ($token, $istack, $lang, $ver) = @_;
    die unless (astlib_is_symbol($token));
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    # TODO python以外でのfunction
    my $symbol = astlib_get_symbol($token);
    if ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $istack = st_var_python_declare($istack, $symbol);
        ("$symbol", $istack);
    } else {
        die;
    }
}

# return: $source
sub _gent_function_sub {
    my ($funcname, $args_source, $body_source, $indent, $body_indent, $lang, $ver) = @_;
    if ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        "def $funcname $args_source:\n" .
        "$body_indent$body_source\n";
    } else {
        # TODO python以外でのfunction
        die;
    }
}

sub st_function_args_stack {
    my ($parent_istack, $lang, $ver) = @_;
    $parent_istack;
    # TODO perl, ruby, python, php のfunctionにおけるistackの扱い
}

sub st_function_body_stack {
    my ($parent_istack, $args_istack, $lang, $ver) = @_;
    istack_append_indent($args_istack, get_source_indent($lang, $ver));
    # TODO perl, ruby, python, php のfunctionにおけるistackの扱い
}

sub st_function_result {
    my ($parent_istack, $body_istack, $lang, $ver) = @_;
    $parent_istack;
    # TODO perl, ruby, python, php のfunctionにおけるistackの扱い
}

