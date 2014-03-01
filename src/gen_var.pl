
# return: ($source, $istack)
sub genl_var_ref {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol($head)) {
        if (@list) {
            die create_dying_msg_unexpected(shift(@list));
        }
        my $varname = astlib_get_symbol($head);
        genl_var_ref_varname($varname, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source, $istack)
sub genl_var_ref_varname {
    my ($varname, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    die if ($lang ne $LANG_SH && $ver < 2);
    if ($lang eq $LANG_SH) {
        ('$' . $varname, $istack);
    } elsif ($lang eq $LANG_PERL) {
        ('$' . $varname, $istack);
    } elsif ($lang eq $LANG_RUBY) {
        ($varname, $istack);
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        ($varname, $istack);
    } elsif ($lang eq $LANG_PHP) {
        ('$' . $varname, $istack);
    } else {
        die;
    }
}

# return: ($source, $istack)
sub genl_var_assign {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    if (astlib_is_symbol($head)) {
        my $source;
        genl_var_assign_1(astlib_get_symbol($head), \@list, $list_close_line_no, $istack, $lang, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

# return: ($source, $istack)
sub genl_var_assign_1 {
    my ($varname, $list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die if ($lang eq $LANG_SEXPR);
    if ($lang eq $LANG_SH) {
        return genl_var_sh_assign_1($varname, $list, $list_close_line_no, $istack, $ver);
    }
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    die create_dying_msg_unexpected(shift(@list)) if (@list);
    my ($source, $_istack) = gent_expr($head, $OP_ORDER_MIN, $istack, $lang, $ver);
    my $result;
    if ($lang eq $LANG_PERL) {
        if (st_var_perl_exists($istack, $varname)) {
            if (st_var_perl_is_scalar($istack, $varname)) {
                $result = '$' . $varname . ' = ' . $source;
            } else {
                die; # TODO
            }
        } else {
            $result = 'my $' . $varname . ' = ' . $source;
            $istack = st_var_perl_declare_scalar($istack, $varname);
        }
    } elsif ($lang eq $LANG_RUBY) {
        $result = $varname . ' = ' . $source;
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $result = $varname . ' = ' . $source;
    } elsif ($lang eq $LANG_PHP) {
        $result = '$' . $varname . ' = ' . $source;
    } else {
        die;
    }
    ($result, $istack);
}

# return: ($source, $istack)
sub genl_var_sh_assign_1 {
    my ($varname, $list, $list_close_line_no, $istack, $ver) = @_;
    # TODO indent
    die unless (defined($istack));
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    my ($source, $_istack) = gent_sh_argument($head, $istack, $ver);
    my $result = $varname . '=' . $source;
    if (@list) {
        my ($source, $_istack) =
            genl_sh_command(\@list, $list_close_line_no, 1, 1, 1, 1, '', '', '', $istack, $ver);
        $result = $result . ' ' . $source;
        # TODO パイプの時に括弧が必要
    } else {
        $istack = st_var_sh_declare_shell($istack, $varname);
    }
    ($result, $istack);
}

sub st_var_perl_declare_scalar {
    my ($istack, $varname) = @_;
    die if ($istack->{lang} ne $LANG_PERL);
    istack_sub_set_var_info($istack, $varname, 'scalar');
}

sub st_var_sh_declare_shell {
    my ($istack, $varname) = @_;
    die if ($istack->{lang} ne $LANG_SH);
    istack_sub_set_var_info($istack, $varname, 'shell');
}

sub st_var_sh_exists {
    my ($istack, $varname) = @_;
    die if ($istack->{lang} ne $LANG_SH);
    if (defined(istack_sub_get_var_info($istack, $varname))) {
        1;
    } else {
        '';
    }
}

sub st_var_perl_exists {
    my ($istack, $varname) = @_;
    die if ($istack->{lang} ne $LANG_PERL);
    if (defined(istack_sub_get_var_info($istack, $varname))) {
        1;
    } else {
        '';
    }
}

sub st_var_perl_is_scalar {
    my ($istack, $varname) = @_;
    die if ($istack->{lang} ne $LANG_PERL);
    my $info = istack_sub_get_var_info($istack, $varname);
    if (!defined($info)) {
        '';
    } elsif ($info eq 'scalar') {
        1;
    } else {
        '';
    }
}

