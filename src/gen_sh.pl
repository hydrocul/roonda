
sub genl_sh_statement {
    my ($list_ref, $close_line_no, $ver) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        return '';
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if ($token eq $KEYWD_SH_EXEC) {
            'exec ' . genl_sh_command(\@list);
        } elsif ($token eq $KEYWD_SH_ASSIGN) {
            genl_sh_assign(\@list, $close_line_no);
        } else {
            unshift(@list, $head);
            genl_sh_command(\@list);
        }
    } else {
        unshift(@list, $head);
        genl_sh_command(\@list);
    }
}

sub genl_sh_assign {
    my ($list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($close_line_no) unless (defined($head));
    if (astlib_is_symbol($head)) {
        genl_sh_assign_1(astlib_get_symbol($head), \@list, $close_line_no);
    } else {
        die create_dying_msg_unexpected($head);
    }
}

sub genl_sh_assign_1 {
    my ($varname, $list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    die create_dying_msg_unexpected_closing($close_line_no) unless (defined($head));
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

sub gent_sh_command {
    my ($token_ref) = @_;
    if (astlib_is_list($token_ref)) {
        genl_sh_command(astlib_get_list($token_ref), astlib_get_close_line_no($token_ref));
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub gent_sh_command_pipe_element {
    my ($token_ref, $is_first, $is_last) = @_;
    if (astlib_is_list($token_ref)) {
        genl_sh_command_pipe_element(astlib_get_list($token_ref),
                                         $is_first, $is_last,
                                         astlib_get_close_line_no($token_ref));
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub genl_sh_command {
    my ($list_ref, $close_line_no) = @_;
    _genl_sh_command_sub($list_ref, '', '', '', $close_line_no);
}

sub genl_sh_command_pipe_element {
    my ($list_ref, $is_first, $is_last, $close_line_no) = @_;
    _genl_sh_command_sub($list_ref, 1, $is_first, $is_last, $close_line_no);
}

sub _genl_sh_command_sub {
    my ($list_ref, $is_pipe_element, $is_pipe_first, $is_pipe_last, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        return '';
    }
    if (astlib_is_symbol_or_string($head)) {
        my $token = astlib_get_symbol_or_string($head);
        if (! $is_pipe_element && $token eq $KEYWD_SH_PIPE) {
            genl_sh_pipe(\@list);
        } elsif ($is_pipe_first && $token eq '<') {
            genl_sh_pipe_first_file(\@list);
        } elsif ($is_pipe_last && $token eq '>') {
            genl_sh_pipe_last_file(\@list);
        } else {
            unshift(@list, $head);
            genl_sh_command_normal(\@list);
        }
    } elsif (astlib_is_list($head)) {
        my ($lang, $bin_path, $source, $ext) =
            genl_exec_for_sh(astlib_get_list($head), \@list, astlib_get_close_line_no($head));
        my $bin_path_escaped = escape_sh_string($bin_path);
        my $script_path = save_file($source, $ext);
        my $script_path_escaped = escape_sh_string($script_path);
        "$bin_path_escaped \$ROONDA_TMP_PATH/$script_path_escaped";
    } else {
        unshift(@list, $head);
        genl_sh_command_normal(\@list);
    }
}

sub genl_sh_pipe {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    my $is_first = 1;
    my $is_last = '';
    while () {
        my $head = shift(@list);
        return $result unless (defined($head));
        $is_last = 1 unless (@list);
        my $source = gent_sh_command_pipe_element($head, $is_first, $is_last);
        $result = $result . ' | ' if ($result);
        $result = $result . $source;
        $is_first = '';
    }
}

sub genl_sh_pipe_first_file {
    my ($list_ref) = @_;
    my @list = @$list_ref;
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

sub genl_sh_pipe_last_file {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    if (@list == 0) {
        return 'cat > /dev/null';
    } elsif (@list == 1) {
        my $result = '';
        my $head = shift(@list);
        my $source = gent_sh_argument($head);
        return 'cat > ' . $source;
    } else {
        my $result = '';
        while () {
            my $head = shift(@list);
            unless (@list) {
                my $source = gent_sh_argument($head);
                return 'tee ' . $result . ' > ' . $source;
            }
            my $source = gent_sh_argument($head);
            $result = $result . ' ' if ($result);
            $result = $result . $source;
        }
    }
}

sub genl_sh_command_normal {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = gent_sh_argument($head);
        $result = $result . ' ' if ($result);
        $result = $result . $source;
    }
}

sub gent_sh_argument {
    my ($token_ref) = @_;
    if (astlib_is_symbol_or_string($token_ref)) {
        escape_sh_string(astlib_get_symbol_or_string($token_ref));
    } elsif (astlib_is_integer($token_ref)) {
        escape_sh_string(astlib_get_integer($token_ref));
    } elsif (astlib_is_list($token_ref)) {
        genl_sh_argument(astlib_get_list($token_ref));
    } else {
        die create_dying_msg_unexpected($token_ref);
    }
}

sub genl_sh_argument {
    my ($list_ref) = @_;
    my @list = @$list_ref;
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
    my ($list_ref) = @_;
    my $source = genl_sh_command($list_ref);
    escape_sh_backticks($source);
}

sub genl_sh_argument_ref {
    my ($list_ref) = @_;
    my @list = @$list_ref;
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
    my ($list_ref) = @_;
    my @list = @$list_ref;
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

