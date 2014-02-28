
# return: ($source, $istack)
sub genl_sh_statement {
    my ($list, $list_close_line_no, $istack, $ver) = @_;
    die unless (defined($istack));
    genl_sh_command($list, $list_close_line_no, 1, 1, 1, 1, '', 1, 1, $istack, $ver);
}

# return: ($source, $istack)
sub gent_sh_command {
    my ($token,
        $enable_assign, $enable_export, $enable_exec,
        $enable_pipe, $enable_redirect_only,
        $enable_subsh, $enable_group,
        $istack, $ver) = @_;
    die unless (defined($istack));
    if (astlib_is_list($token)) {
        genl_sh_command(astlib_get_list($token), astlib_get_close_line_no($token),
                        $enable_assign, $enable_export, $enable_exec,
                        $enable_pipe, $enable_redirect_only,
                        $enable_subsh, $enable_group,
                        $istack, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

# return: ($source, $istack)
sub genl_sh_command {
    my ($list, $list_close_line_no,
        $enable_assign, $enable_export, $enable_exec,
        $enable_pipe, $enable_redirect_only,
        $enable_subsh, $enable_group,
        $istack, $ver) = @_;
    die unless (defined($istack));
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol($head)) {
        my $source;
        ($source, $istack) =
            _genl_sh_command_head($head, \@list, $list_close_line_no,
                                  $enable_assign, $enable_export, $enable_exec,
                                  $enable_pipe, $enable_redirect_only,
                                  $enable_subsh, $enable_group,
                                  $istack, $ver);
        if (defined($source)) {
            return ($source, $istack);
        }
    }
    _genl_sh_command_arguments($list, $enable_redirect_only, $istack, $ver);
}

# return: ($source, $istack)
sub _genl_sh_command_head {
    my ($head, $list, $list_close_line_no,
        $enable_assign, $enable_export, $enable_exec,
        $enable_pipe, $enable_redirect_only,
        $enable_subsh, $enable_group,
        $istack, $ver) = @_;
    die unless (defined($istack));
    die unless (astlib_is_symbol($head));
    my $head_symbol = astlib_get_symbol($head);
    my $target_lang = get_dst_format_label($head_symbol);
    if ($target_lang) {
        _genl_sh_command_lang($target_lang, $head, $list, $list_close_line_no,
                              $enable_redirect_only,
                              $istack, $ver);
    } elsif ($head_symbol eq $KEYWD_IF) {
        genl_langs_if($list, $list_close_line_no, $istack, $LANG_SH, $ver);
    } elsif ($head_symbol eq $KEYWD_PRINT) {
        genl_langs_print($list, $list_close_line_no, $istack, $LANG_SH, $ver);
    } elsif ($head_symbol eq $KEYWD_ASSIGN) {
        unless ($enable_assign) {
            die create_dying_msg_unexpected($head);
        }
        genl_langs_assign($list, $list_close_line_no, $istack, $LANG_SH, $ver);
    } elsif ($head_symbol eq $KEYWD_SH_EXEC) {
        unless ($enable_exec) {
            die create_dying_msg_unexpected($head);
        }
        my ($source, $_istack) =
            genl_sh_command($list, $list_close_line_no, '', '', '', '', 1, '', '', $istack, $ver);
        ('exec ' . $source, $istack);
    } elsif ($head_symbol eq $KEYWD_SH_EXPORT) {
        unless ($enable_export) {
            die create_dying_msg_unexpected($head);
        }
        genl_sh_export($list, $list_close_line_no, $istack, $ver);
    } elsif ($head_symbol eq $KEYWD_SH_PIPE) {
        unless ($enable_pipe) {
            die create_dying_msg_unexpected($head);
        }
        genl_sh_pipe($list, $list_close_line_no, $istack, $ver);
    } elsif ($head_symbol eq $KEYWD_SH_SUBSH) {
        unless ($enable_subsh) {
            die create_dying_msg_unexpected($head);
        }
        genl_sh_subsh($list, $list_close_line_no, $istack, $ver);
    } elsif ($head_symbol eq $KEYWD_SH_GROUP) {
        unless ($enable_group) {
            die create_dying_msg_unexpected($head);
        }
        genl_sh_group($list, $list_close_line_no, $istack, $ver);
    } elsif ($head_symbol eq $KEYWD_SH_ROONDA) {
        genl_sh_command_roonda($list, $list_close_line_no, $istack, $ver);
    } else {
        (undef, $istack);
    }
}

# return: ($source, $istack)
sub _genl_sh_command_lang {
    my ($target_lang, $target_lang_token, $list, $list_close_line_no,
        $enable_redirect_only,
        $istack, $ver) = @_;
    die unless (defined($istack));
    if ($target_lang eq $LANG_SEXPR) {
        die create_dying_msg_unexpected($target_lang_token);
    }
    if ($ver < 2 && $target_lang ne $LANG_SH) {
        die "Unsupported language: $target_lang";
    }
    my ($bin_path, $bin_path_for_sh, $ext) = lang_to_bin_path($target_lang);
    my $bin_path_escaped = escape_sh_string($bin_path_for_sh);
    if (@$list && astlib_is_heredoc($list->[0])) {
        my @list = ($target_lang_token, @$list);
        _genl_sh_command_arguments(\@list, $enable_redirect_only, $istack, $ver);
    } else {
        my ($source_head, $source_body) =
            genl_exec_lang($list, $list_close_line_no, $target_lang, $ver);
        my $source = $source_head . $source_body;
        my $script_path = save_file($source, $ext, 1, '');
        my $script_path_escaped = escape_sh_string($script_path);
        ("$bin_path_escaped \$ROONDA_TMP_PATH/$script_path_escaped", $istack);
    }
}

# return: ($source, $istack)
sub _genl_sh_command_arguments {
    my ($args_list, $enable_redirect_only, $istack, $ver) = @_;
    die unless (defined($istack));
    my @args_list = @$args_list;
    my $result = '';
    my $result_redirect = '';
    unless ($enable_redirect_only) {
        my $head = shift(@args_list);
        $result = gent_sh_argument($head, $istack, $ver); # TODO istack
    }
    foreach my $elem (@args_list) {
        my ($source, $is_redirect) = gent_sh_argument_or_redirect($elem, $ver);
        if ($is_redirect) {
            $result_redirect = $result_redirect . ' ' if ($result_redirect ne '');
            $result_redirect = $result_redirect . $source;
        } else {
            $result = $result . ' ' if ($result ne '');
            $result = $result . $source;
        }
    }
    if ($result_redirect eq '') {
        ($result, $istack)
    } elsif ($result eq '') {
        ($result_redirect, $istack)
    } else {
        ($result . ' ' . $result_redirect, $istack);
    }
}

# return: ($source, $istack)
sub genl_sh_assign_1 {
    my ($varname, $list, $list_close_line_no, $istack, $ver) = @_;
    # TODO indent
    die unless (defined($istack));
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    my $source = gent_sh_argument($head, $istack, $ver);
    my $result = $varname . '=' . $source;
    if (@list) {
        my $source;
        ($source, $istack) =
            genl_sh_command(\@list, $list_close_line_no, 1, 1, 1, 1, '', '', '', $istack, $ver); # TODO istack
        $result = $result . ' ' . $source;
        # TODO パイプの時に括弧が必要
    } else {
        $istack = istack_var_sh_declare_shell($istack, $varname);
    }
    ($result, $istack);
}

# return: ($source, $istack)
sub genl_sh_export {
    my ($list, $list_close_line_no, $istack, $ver) = @_;
    die "TODO genl_sh_export";
}

# return: ($source, $istack)
sub genl_sh_pipe {
    my ($list, $list_close_line_no, $istack, $ver) = @_;
    my $result = '';
    foreach my $elem (@$list) {
        my $source;
        ($source, $istack) = gent_sh_command($elem, 1, 1, '', '', '', 1, 1, $istack, $ver);
        $result = $result . ' | ' if ($result ne '');
        $result = $result . $source;
    }
    ($result, $istack);
}

# return: ($source, $istack)
sub genl_sh_subsh {
    my ($list, $list_close_line_no, $istack, $ver) = @_;
    my $indent = istack_get_indent($istack);
    my $inner_istack = istack_append_indent($istack, get_source_indent($LANG_SH, $ver));
    my $indent2 = istack_get_indent($inner_istack);
    my $result = '(';
    foreach my $elem (@$list) {
        my $source;
        ($source, $inner_istack) =
            gent_sh_command($elem, 1, 1, '', '', '', 1, 1, $inner_istack, $ver);
        $result = $result . "\n$indent2";
        $result = $result . $source;
    }
    $result = $result . "\n$indent)";
    ($result, $istack);
}

# return: ($source, $istack)
sub genl_sh_group {
    my ($list, $list_close_line_no, $istack, $ver) = @_;
    my $indent = istack_get_indent($istack);
    my $indent2 = $indent . get_source_indent($LANG_SH);
    my $result = '{';
    foreach my $elem (@$list) {
        my $source;
        ($source, $istack) = gent_sh_command($elem, 1, 1, '', '', '', 1, 1, $istack, $ver);
        $result = $result . "\n$indent2";
        $result = $result . $source;
    }
    $result = $result . "\n$indent}";
    ($result, $istack); # TODO istack
}

# return: ($source, $istack)
sub genl_sh_command_roonda {
    my ($list, $list_close_line_no, $istack, $ver) = @_;
    die unless (defined($istack));
    my @list = @$list;
    my $head = shift(@list);
    if ($head && astlib_is_symbol_or_string($head)) {
        my $symbol = astlib_get_symbol_or_string($head);
        if ($symbol =~ /\A([a-z0-9]+)-to-([a-z0-9]+)\z/) {
            my $format_from = get_src_format_label($1);
            my $lang_to = get_dst_format_label($2);
            if (defined($format_from) && defined($lang_to)) {
                return genl_sh_command_roonda_convert($format_from, $lang_to,
                                                      \@list, $list_close_line_no, $istack, $ver);
            }
        }
    }
    unshift(@list, $head) if ($head);
    my $result = "\$$ENV_SELF_PATH";
    if (@list) {
        my ($source, $_istack) =
            _genl_sh_command_arguments(\@list, 1, $istack, $ver);
        $result = $result . ' ' . $source;
    }
    ($result, $istack);
}

# return: ($source, $istack)
sub genl_sh_command_roonda_convert {
    my ($format_from, $lang_to, $list, $list_close_line_no, $istack, $ver) = @_;
    my @list = @$list;
    if (@list) {
        die create_dying_msg_unexpected(shift(@list));
    }
    my $source = "\$$ENV_SELF_PATH --v$ver " .
        escape_sh_string("--$format_from-to-$lang_to") . "-obj";
    ($source, $istack);
}

# return ($source, $is_redirect)
sub gent_sh_argument_or_redirect {
    my ($token, $ver) = @_;
    if (astlib_is_list($token)) {
        genl_sh_argument_or_redirect(astlib_get_list($token),
                                     astlib_get_close_line_no($token), $ver);
    } else {
        my $istack = istack_create($LANG_SH, $ver); # TODO istack
        (gent_sh_argument($token, $istack, $ver), '');
    }
}

# return ($source, $is_redirect)
sub genl_sh_argument_or_redirect {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $symbol = astlib_get_symbol_or_string($head);
        if ($symbol eq '<') {
            return (genl_sh_redirect_in(\@list, $list_close_line_no, $ver), 1);
        } elsif ($symbol eq '>') {
            return (genl_sh_redirect_out(\@list, $list_close_line_no, $ver), 1);
        } elsif ($symbol eq '>>') {
            return (genl_sh_redirect_append(\@list, $list_close_line_no, $ver), 1);
        }
    }
    (genl_sh_argument($list, $list_close_line_no, $ver), '');
}

sub gent_sh_argument {
    my ($token, $istack, $ver) = @_;
    die unless (defined($istack));
    if (astlib_is_symbol($token)) {
        my $symbol = astlib_get_symbol($token);
        if ($symbol eq $KEYWD_TRUE) {
            die create_dying_msg_unexpected($token); # TODO
        } elsif ($symbol eq $KEYWD_FALSE) {
            die create_dying_msg_unexpected($token); # TODO
        } else {
            if (istack_var_sh_exists($istack, $symbol)) {
                my $source;
                ($source, $istack) = genl_langs_ref_varname($symbol, $istack, $LANG_SH, $ver); # TODO istack
                $source = '"' . $source . '"';
                return $source;
            }
        }
    }
    if (astlib_is_symbol_or_string($token)) {
        escape_sh_string(astlib_get_symbol_or_string($token));
    } elsif (astlib_is_heredoc($token)) {
        "\$$ENV_TMP_PATH/" . escape_sh_string(astlib_get_heredoc_name($token));
    } elsif (astlib_is_integer($token)) {
        escape_sh_string(astlib_get_integer($token));
    } elsif (astlib_is_list($token)) {
        genl_sh_argument(astlib_get_list($token), astlib_get_close_line_no($token), $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_sh_argument {
    my ($list, $list_close_line_no, $ver) = @_;
    my $istack = istack_create($LANG_SH, $ver); # TODO istack
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        return "''";
    }
    if (astlib_is_symbol_or_string($head)) {
        my $symbol = astlib_get_symbol_or_string($head);
        if ($symbol eq $KEYWD_SH_BACKTICKS) {
            '"' . genl_sh_argument_backticks(\@list, $list_close_line_no, $ver) . '"';
        } elsif ($symbol eq $KEYWD_REF) {
            '"' . genl_langs_ref(\@list, $list_close_line_no, $istack, $LANG_SH, $ver) . '"';
        } elsif ($symbol eq $KEYWD_STRCAT) {
            genl_sh_argument_strcat(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq '+' || $symbol eq '-' ||
            $symbol eq '*' || $symbol eq '/' || $symbol eq '%') {
            if ($ver < 2) {
                die "Unsupported: $symbol";
            }
            my $istack = istack_create($LANG_SH, $ver); # TODO istack
            my $source = genl_langs_expr($list, $OP_ORDER_MIN, $list_close_line_no, $istack, $LANG_SH, $ver);
            escape_sh_backticks('expr ' . $source);
        } else {
            die create_dying_msg_unexpected($head);
        }
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_sh_argument_backticks {
    my ($list, $list_close_line_no, $ver) = @_;
    my $istack = istack_create($LANG_SH, $ver); # TODO istack
    my $source;
    ($source, $istack) =
        genl_sh_command($list, $list_close_line_no, 1, 1, '', 1, '', 1, 1, $istack, $ver); # TODO istack
    escape_sh_backticks($source);
}

sub genl_sh_argument_strcat {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $result = '';
    foreach my $elem (@list) {
        my $istack = istack_create($LANG_SH, $ver); # TODO istack
        $result = $result . gent_sh_argument($elem, $istack, $ver);
    }
    $result;
}

sub genl_sh_redirect_in {
    my ($list, $list_close_line_no, $ver) = @_;
    _genl_sh_redirect_in_out_sub($list, $list_close_line_no, $ver, '<', 1);
}

sub genl_sh_redirect_out {
    my ($list, $list_close_line_no, $ver) = @_;
    _genl_sh_redirect_in_out_sub($list, $list_close_line_no, $ver, '>', 1);
}

sub genl_sh_redirect_append {
    my ($list, $list_close_line_no, $ver) = @_;
    _genl_sh_redirect_in_out_sub($list, $list_close_line_no, $ver, '>>', '');
}

sub _genl_sh_redirect_in_out_sub {
    my ($list, $list_close_line_no, $ver, $op, $enable_dup) = @_;
    my @list = @$list;
    my $head1 = shift(@list);
    my $head2 = shift(@list);
    unless  (defined($head1)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $h;
    if (defined($head2)) {
        if (@list) {
            die create_dying_msg_unexpected(shift(@list));
        }
        if (astlib_is_integer($head1)) {
            $h = astlib_get_integer($head1);
        } else {
            die create_dying_msg_unexpected($head1);
        }
    } else {
        $h = '';
        $head2 = $head1;
    }
    if ($enable_dup && astlib_is_integer($head2)) {
        my $num = astlib_get_integer($head2);
        $h . $op . '&' . $num;
    } else {
        my $istack = istack_create($LANG_SH, $ver); # TODO istack
        $h . $op . ' ' . gent_sh_argument($head2, $istack, $ver);
    }
}

