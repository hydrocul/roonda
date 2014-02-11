
sub genl_sh_statement {
    my ($list, $indent, $list_close_line_no, $ver) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        return '';
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_SH_EXEC) {
            $indent . 'exec ' . genl_sh_command(\@list, $list_close_line_no, $ver) . "\n";
        } elsif ($token eq $KEYWD_SH_ASSIGN) {
            $indent . genl_sh_assign(\@list, $list_close_line_no, $ver) . "\n";
        } else {
            unshift(@list, $head);
            $indent . genl_sh_command(\@list, $list_close_line_no, $ver) . "\n";
        }
    } else {
        unshift(@list, $head);
        $indent . genl_sh_command(\@list, $list_close_line_no, $ver) . "\n";
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
    if (@list) {
        my $head = shift(@list);
        die create_dying_msg_unexpected($head);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $value_escaped = escape_sh_string(astlib_get_symbol_or_string($head));
        "$varname=$value_escaped";
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub gent_sh_command_pipe_element {
    my ($token, $is_first) = @_;
    if (astlib_is_list($token)) {
        genl_sh_command_pipe_element(astlib_get_list($token),
                                     $is_first,
                                     astlib_get_close_line_no($token));
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_sh_command {
    my ($list, $list_close_line_no, $ver) = @_;
    _genl_sh_command_sub($list, '', $list_close_line_no);
}

sub genl_sh_command_pipe_element {
    my ($list, $is_first, $list_close_line_no) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($is_first && $token eq '<') {
            return genl_sh_pipe_first_file(\@list);
        } elsif (! $is_first && $token eq '>') {
            return genl_sh_pipe_stdout_to_file(\@list, '');
        } elsif (! $is_first && $token eq '>>') {
            return genl_sh_pipe_stdout_to_file(\@list, 1);
        }
    }
    unshift(@list, $head);
    my $source = _genl_sh_command_sub(\@list, 1, $list_close_line_no);
    if ($is_first) {
        $source;
    } else {
        " | $source";
    }
}

sub _genl_sh_command_sub {
    my ($list, $is_pipe_element, $list_close_line_no) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if (! $is_pipe_element && $token eq $KEYWD_SH_PIPE) {
            return genl_sh_pipe(\@list);
        }
    } elsif (astlib_is_list($head)) {
        my $result = _genl_sh_command_sub_list(
            \@list, astlib_get_list($head), astlib_get_close_line_no($head));
        if (defined($result)) {
            return $result;
        }
    }
    unshift(@list, $head);
    genl_sh_command_normal(\@list, $list_close_line_no);
}

sub _genl_sh_command_sub_list {
    my ($list, $cmd_list, $cmd_list_close_line_no) = @_;
    my $ver = 1; # TODO
    my ($lang, $bin_path, $bin_path_for_sh, $source, $ext) =
        genl_exec_head_body($cmd_list, $cmd_list_close_line_no, $list, $ver, '');
    return undef unless ($lang);
    my $bin_path_escaped = escape_sh_string($bin_path_for_sh);
    my $script_path = save_file($source, $ext, 1, '');
    my $script_path_escaped = escape_sh_string($script_path);
    "$bin_path_escaped \$ROONDA_TMP_PATH/$script_path_escaped";
}

sub genl_sh_pipe {
    my ($list) = @_;
    my @list = @$list;
    my $result = '';
    my $is_first = 1;
    while () {
        my $head = shift(@list);
        return $result unless (defined($head));
        my $source = gent_sh_command_pipe_element($head, $is_first);
        $result = $result . $source;
        $is_first = '';
    }
}

sub genl_sh_pipe_first_file {
    my ($list) = @_;
    my @list = @$list;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            if ($result) {
                return 'cat ' . $result;
            } else {
                return 'cat /dev/null';
            }
        }
        my $source = gent_sh_argument($head);
        $result = $result . ' ' if ($result);
        $result = $result . $source;
    }
}

sub genl_sh_pipe_stdout_to_file {
    my ($list, $is_append) = @_;
    my @list = @$list;
    if (@list == 0) {
        return '';
    } elsif (@list == 1) {
        my $result = '';
        my $head = shift(@list);
        my $source = gent_sh_argument($head);
        if ($is_append) {
            return ' >> ' . $source;
        } else {
            return ' > ' . $source;
        }
    } else {
        my $result = '';
        while () {
            my $head = shift(@list);
            unless (@list) {
                my $source = gent_sh_argument($head);
                if ($is_append) {
                    return '| tee -a ' . $result . ' >> ' . $source;
                } else {
                    return '| tee ' . $result . ' > ' . $source;
                }
            }
            my $source = gent_sh_argument($head);
            $result = $result . ' ' if ($result);
            $result = $result . $source;
        }
    }
}

sub genl_sh_command_normal {
    my ($list, $list_close_line_no) = @_;
    my $result;
    my $head = shift(@$list);
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_SH_ROONDA) {
            return genl_sh_command_roonda($list, $list_close_line_no);
        } else {
            $result = gent_sh_argument($head);
        }
    } else {
        $result = gent_sh_argument($head);
    }
    foreach my $elem (@$list) {
        my $source = gent_sh_argument($elem);
        $result = $result . ' ' if ($result);
        $result = $result . $source;
    }
    return $result;
}

sub genl_sh_command_roonda {
    my ($list, $list_close_line_no) = @_;
    my $head = shift(@$list);
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token =~ /\A([a-z0-9]+)-to-([a-z0-9]+)\Z/) {
            my $format_from = get_src_format_label($1);
            my $lang_to = get_dst_format_label($2);
            if (defined($format_from) && defined($lang_to)) {
                return genl_sh_command_roonda_embed_2($token, $lang_to, $list, $list_close_line_no);
            } else {
                unshift(@$list, $head);
            }
        } else {
            unshift(@$list, $head);
        }
    } else {
        unshift(@$list, $head);
    }
    my $result = "\$$ENV_SELF_PATH";
    foreach my $elem (@$list) {
        my $source = gent_sh_argument($elem);
        $result = $result . ' ' . $source;
    }
    return $result;
}

sub genl_sh_command_roonda_embed_2 {
    my ($from_to_str, $lang_to, $list, $list_close_line_no) = @_;
    my $ver = 1; # TODO
    my $result = "\$$ENV_SELF_PATH --v$ver --" . escape_sh_string($from_to_str) . "-obj";
    my $head = shift(@$list);
    unless (defined($head)) {
        return $result;
    }
    if ($lang_to eq $LANG_SEXPR) {
        die create_dying_msg_unexpected($head);
    }
    my $fname;
    if (astlib_is_heredoc($head)) {
        die create_dying_msg_unexpected(shift(@$list)) if (@$list);
        $fname = astlib_get_heredoc_name($head);
    } elsif (astlib_is_list($head)) {
        my $source = genl_langs($list, $lang_to, $ver);
        my ($bin_path, $ext) = lang_to_bin_path($lang_to);
        $fname = save_file($source, $ext, 1, '');
    } else {
        die create_dying_msg_unexpected($head);
    }
    $result = $result . " \$$ENV_TMP_PATH/" . escape_sh_string($fname);
    $result;
}

sub gent_sh_argument {
    my ($token) = @_;
    if (astlib_is_symbol_or_string($token)) {
        escape_sh_string(astlib_get_symbol_or_string($token));
    } elsif (astlib_is_heredoc($token)) {
        "\$$ENV_TMP_PATH/" . escape_sh_string(astlib_get_heredoc_name($token));
    } elsif (astlib_is_integer($token)) {
        escape_sh_string(astlib_get_integer($token));
    } elsif (astlib_is_list($token)) {
        genl_sh_argument(astlib_get_list($token));
    } else {
        die create_dying_msg_unexpected($token);
    }
}

sub genl_sh_argument {
    my ($list) = @_;
    my @list = @$list;
    my $head = shift(@list);
    unless (defined($head)) {
        return "''";
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_SH_BACKTICKS) {
            genl_sh_argument_backticks(\@list);
        } elsif ($token eq $KEYWD_SH_REF) {
            genl_sh_argument_ref(\@list);
        } elsif ($token eq $KEYWD_STRCAT) {
            genl_sh_argument_strcat(\@list);
        } else {
            die create_dying_msg_unexpected($head);
        }
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_sh_argument_backticks {
    my ($list) = @_;
    my $list_close_line_no = 0; # TODO
    my $ver = 1; # TODO
    my $source = genl_sh_command($list, $list_close_line_no, $ver);
    escape_sh_backticks($source);
}

sub genl_sh_argument_ref {
    my ($list) = @_;
    my @list = @$list;
    my $head = shift(@list);
    die "Unexpected endo of list" unless (defined($head));
    if (astlib_is_symbol($head)) {
        if (@list) {
            my $head = shift(@list);
            die create_dying_msg_unexpected($head);
        }
        '$' . astlib_get_symbol($head);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_sh_argument_strcat {
    my ($list) = @_;
    my @list = @$list;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = gent_sh_argument($head);
        $result = $result . $source;
    }
}

