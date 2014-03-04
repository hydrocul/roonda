
# return: ($source, $istack)
sub genl_import {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    # TODO python以外でのimport
    my @list = @$list;
    my $from_token = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($from_token));
    my $import_token = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($import_token));
    my $as_token = shift(@list);
    die create_dying_msg_unexpected(shift(@list)) if (@list);
    my $from_source = _gent_import_python_from($from_token);
    my ($import_source, $import_istack) = _gent_import_python_import($import_token, $istack, $ver);
    my $as_source = '';
    if (defined($as_token)) {
        ($as_source, $istack) = _gent_import_python_as($as_token, $istack, $ver);
    } else {
        $istack = $import_istack;
    }
    my $source = "$from_source$import_source$as_source";
    ($source, $istack);
}

# return: $source
sub _gent_import_python_from {
    my ($token, $ver) = @_;
    if (astlib_is_symbol($token)) {
        my $symbol = astlib_get_symbol($token);
        "from $symbol ";
    } elsif (astlib_is_list($token)) {
        my @list = @{astlib_get_list($token)};
        if (@list) {
            my ($source, $istack) = _gent_import_python_dot(\@list, undef, $ver);
            "from $source ";
        } else {
            "";
        }
    } else{
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub _gent_import_python_import {
    my ($token, $istack, $ver) = @_;
    if (astlib_is_symbol($token)) {
        my $symbol = astlib_get_symbol($token);
        if ($symbol ne '*') {
            $istack = st_var_python_declare_module($istack, $symbol);
        }
        ("import $symbol", $istack);
    } elsif (astlib_is_list($token)) {
        my @list = @{astlib_get_list($token)};
        if (@list) {
            my $source;
            ($source, $istack) = _gent_import_python_dot(\@list, $istack, $ver);
            ("import $source", $istack);
        } else {
            die create_dying_msg_unexpected_closing(astlib_get_close_line_no($token));
        }
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub _gent_import_python_as {
    my ($token, $istack, $ver) = @_;
    if (astlib_is_symbol($token)) {
        my $symbol = astlib_get_symbol($token);
        $istack = st_var_python_declare_module($istack, $symbol);
        (" as $symbol", $istack);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub _gent_import_python_dot {
    my ($list, $istack, $ver) = @_;
    my $result = '';
    #my $last_symbol = undef;
    foreach my $elem (@$list) {
        die create_dying_msg_unexpected($elem) unless (astlib_is_symbol($elem));
        my $symbol = astlib_get_symbol($elem);
        $result = $result . '.' if ($result);
        $result = $result . $symbol;
    }
    #if (defined($last_symbol) && defined($istack)) {
    #    $istack = st_var_python_declare_module($istack, $last_symbol);
    #}
    ($result, $istack);
}

