
sub genl_sh_statement {
    my ($list, $indent, $list_close_line_no, $ver) = @_;
    # TODO $indentの対応
    genl_sh_command($list, $list_close_line_no, 1, 1, 1, 1, '', $ver);
}

sub gent_sh_command {
    my ($token,
        $enable_assign, $enable_export, $enable_exec, $enable_pipe, $enable_redirect_only, $ver) = @_;
    if (astlib_is_list($token)) {
        genl_sh_command(astlib_get_list($token), astlib_get_close_line_no($token),
            $enable_assign, $enable_export, $enable_exec, $enable_pipe, $enable_redirect_only, $ver);
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_sh_command {
    my ($list, $list_close_line_no,
        $enable_assign, $enable_export, $enable_exec, $enable_pipe, $enable_redirect_only, $ver) = @_;
    my $indent = ''; # TODO
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my @args_list = ();
    if (astlib_is_symbol($head)) {
        my $symbol = astlib_get_symbol($head);
        my $target_lang = get_dst_format_label($symbol);
        if ($target_lang) {
            if ($target_lang eq $LANG_SEXPR) {
                die create_dying_msg_unexpected($head);
            }
            my $source = genl_exec_lang(\@list, $list_close_line_no, $target_lang, $ver);
            my ($lang, $bin_path, $bin_path_for_sh, $ext) = bin_path_to_lang($target_lang);
            my $bin_path_escaped = escape_sh_string($bin_path_for_sh);
            my $script_path = save_file($source, $ext, 1, '');
            my $script_path_escaped = escape_sh_string($script_path);
            return "$bin_path_escaped \$ROONDA_TMP_PATH/$script_path_escaped";
        }
        if ($symbol eq $KEYWD_IF) {
            return genl_langs_if(\@list, $list_close_line_no, $indent, $LANG_SH, $ver);
        } elsif ($symbol eq $KEYWD_PRINT) {
            return genl_langs_print(\@list, $list_close_line_no, $indent, $LANG_SH, $ver);
        } elsif ($symbol eq $KEYWD_SH_EXEC) {
            unless ($enable_exec) {
                die create_dying_msg_unexpected($head);
            }
            return 'exec ' . genl_sh_command(\@list, $list_close_line_no, '', '', '', '', 1, $ver);
        } elsif ($symbol eq $KEYWD_SH_ASSIGN) {
            unless ($enable_assign) {
                die create_dying_msg_unexpected($head);
            }
            return genl_sh_assign(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq $KEYWD_SH_EXPORT) {
            unless ($enable_export) {
                die create_dying_msg_unexpected($head);
            }
            return genl_sh_export(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq $KEYWD_SH_PIPE) {
            unless ($enable_pipe) {
                die create_dying_msg_unexpected($head);
            }
            return genl_sh_pipe(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq $KEYWD_SH_ROONDA) {
            return genl_sh_command_roonda(\@list, $list_close_line_no, $ver);
        } else {
            push(@args_list, $head);
        }
    } else {
        push(@args_list, $head);
    }
    push(@args_list, @list);
    _genl_sh_command_arguments(\@args_list, $enable_redirect_only, $ver);
}

sub _genl_sh_command_arguments {
    my ($args_list, $enable_redirect_only, $ver) = @_;
    my @args_list = @$args_list;
    my $result = '';
    my $result_redirect = '';
    unless ($enable_redirect_only) {
        my $head = shift(@args_list);
        $result = gent_sh_argument($head, $ver);
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
        $result;
    } elsif ($result eq '') {
        $result_redirect;
    } else {
        $result . ' ' . $result_redirect;
    }
}

sub genl_sh_assign {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    if (astlib_is_symbol($head)) {
        genl_sh_assign_1(astlib_get_symbol($head), \@list, $list_close_line_no, $ver);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_sh_assign_1 {
    my ($varname, $list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($head));
    my $source = gent_sh_argument($head);
    my $result = $varname . '=' . $source;
    if (@list) {
        $result = $result . ' ' . genl_sh_command(\@list, $list_close_line_no, 1, 1, 1, 1, '', $ver);
        # TODO パイプの時に括弧が必要
    }
    $result;
}

sub genl_sh_export {
    my ($list, $list_close_line_no, $ver) = @_;
    die "TODO genl_sh_export";
}

sub genl_sh_pipe {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $result = '';
    foreach my $elem (@list) {
        my $source = gent_sh_command($elem, 1, 1, '', '', '', $ver);
        $result = $result . ' | ' if ($result ne '');
        $result = $result . $source;
    }
    $result;
}

sub genl_sh_command_roonda {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    if ($head && astlib_is_symbol_or_string($head)) {
        my $symbol = astlib_get_symbol_or_string($head);
        if ($symbol =~ /\A([a-z0-9]+)-to-([a-z0-9]+)\Z/) {
            my $format_from = get_src_format_label($1);
            my $lang_to = get_dst_format_label($2);
            if (defined($format_from) && defined($lang_to)) {
                return genl_sh_command_roonda_convert($format_from, $lang_to,
                                                      \@list, $list_close_line_no, $ver);
            }
        }
    }
    unshift(@list, $head) if ($head);
    my $result = "\$$ENV_SELF_PATH";
    if (@list) {
        $result = $result . ' ' . _genl_sh_command_arguments(\@list, 1, $ver);
    }
    return $result;
}

sub genl_sh_command_roonda_convert {
    my ($format_from, $lang_to, $list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    if (@list) {
        die create_dying_msg_unexpected(shift(@list));
    }
    "\$$ENV_SELF_PATH --v$ver " . escape_sh_string("--$format_from-to-$lang_to") . "-obj";
}

# return ($source, $is_redirect)
sub gent_sh_argument_or_redirect {
    my ($token, $ver) = @_;
    if (astlib_is_list($token)) {
        genl_sh_argument_or_redirect(astlib_get_list($token),
                                     astlib_get_close_line_no($token), $ver);
    } else {
        (gent_sh_argument($token, $ver), '');
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
    my ($token, $ver) = @_;
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
    my $indent = ''; # TODO
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        return "''";
    }
    if (astlib_is_symbol_or_string($head)) {
        my $symbol = astlib_get_symbol_or_string($head);
        if ($symbol eq $KEYWD_SH_BACKTICKS) {
            genl_sh_argument_backticks(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq $KEYWD_SH_REF) {
            genl_sh_argument_ref(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq $KEYWD_STRCAT) {
            genl_sh_argument_strcat(\@list, $list_close_line_no, $ver);
        } elsif ($symbol eq '+' || $symbol eq '-' ||
            $symbol eq '*' || $symbol eq '/' || $symbol eq '%') {
            my $source = genl_langs_expr($list, $OP_ORDER_MIN, $list_close_line_no, $indent, $LANG_SH, $ver);
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
    my $source = genl_sh_command($list, $list_close_line_no, 1, 1, '', 1, '', $ver);
    escape_sh_backticks($source);
}

sub genl_sh_argument_ref {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol($head)) {
        if (@list) {
            die create_dying_msg_unexpected(shift(@list));
        }
        my $symbol = astlib_get_symbol($head);
        '$' . $symbol;
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_sh_argument_strcat {
    my ($list, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $result = '';
    foreach my $elem (@list) {
        $result = $result . gent_sh_argument($elem, $ver);
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
        $h . $op . ' ' . gent_sh_argument($head2, $ver);
    }
}

