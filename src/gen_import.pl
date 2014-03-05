
# return: ($source, $istack)
sub genl_import {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die unless ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3);
    my @list = @$list;
    my $token1 = shift(@list);
    my $token2 = shift(@list);
    my $token3 = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($token1));
    my $source;
    my $varname;
    if (astlib_is_symbol($token1)) {
        my $symbol = astlib_get_symbol($token1);
        $source = $symbol;
        $varname = $symbol;
    } elsif (astlib_is_list($token1)) {
        $source = _gent_import_python_dot(astlib_get_list($token1), astlib_get_close_line_no($token1));
    } else {
        die create_dying_msg_unexpected($token1);
    }
    if (!defined($token2)) {
        $source = "import $source";
    } elsif (astlib_is_symbol($token2)) {
        my $symbol = astlib_get_symbol($token2);
        $source = "from $source import $symbol";
        if ($symbol ne '*') {
            $varname = $symbol;
        }
    } elsif (astlib_is_list($token2)) {
        my @token2_list = @{astlib_get_list($token2)};
        if (@token2_list) {
            die create_dying_msg_unexpected($token2);
        }
        $source = "import $source";
    } else {
        die create_dying_msg_unexpected($token2);
    }
    if (defined($token3)) {
        if (astlib_is_symbol($token3)) {
            my $symbol = astlib_get_symbol($token3);
            $source = "$source as $symbol";
            $varname = $symbol;
        } else {
            die create_dying_msg_unexpected($token3);
        }
        die create_dying_msg_unexpected(shift(@list)) if (@list);
    }
    $istack = st_var_python_declare($istack, $varname) if (defined($varname));
    ($source, $istack);
}


# return: $source
sub _gent_import_python_dot {
    my ($list, $list_close_line_no) = @_;
    my $result = '';
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (@$list);
    foreach my $elem (@$list) {
        die create_dying_msg_unexpected($elem) unless (astlib_is_symbol($elem));
        my $symbol = astlib_get_symbol($elem);
        $result = $result . '.' if ($result);
        $result = $result . $symbol;
    }
    $result;
}

