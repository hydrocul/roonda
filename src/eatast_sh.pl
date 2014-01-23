
sub eat_list_sh_statement {
    my ($list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        return '';
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'exec') {
            'exec ' . eat_list_sh_command(\@list);
        } elsif ($token eq 'assign') {
            eat_list_sh_assign(\@list, $close_line_no);
        } else {
            unshift(@list, $head);
            eat_list_sh_command(\@list);
        }
    } else {
        unshift(@list, $head);
        eat_list_sh_command(\@list);
    }
}

sub eat_list_sh_assign {
    my ($list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    die "Unexpected token: `)` (Line: $close_line_no)" unless (defined($head));
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL) {
        eat_list_sh_assign_1($token, \@list, $close_line_no);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_sh_assign_1 {
    my ($varname, $list_ref, $close_line_no) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    die "Unexpected token: `)` (Line: $close_line_no)" unless (defined($head));
    if (@list) {
        my $head = shift(@list);
        my ($type, $line_no, $token, $token_str) = @$head;
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        my $value_escaped = escape_sh_string($token);
        "$varname=$value_escaped";
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_token_sh_command {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        eat_list_sh_command($token);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no), but expected `(`";
    }
}

sub eat_list_sh_command {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        return '';
    }
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'pipe') {
            eat_list_sh_pipe(\@list);
        } else {
            unshift(@list, $head);
            eat_list_sh_command_normal(\@list);
        }
    } elsif ($type eq $TOKEN_TYPE_LIST) {
        my ($lang, $bin_path, $source, $ext) = eat_list_exec_for_sh($token, \@list, $line_no_2);
        my $bin_path_escaped = escape_sh_string($bin_path);
        my $script_path = save_file($source, $ext);
        my $script_path_escaped = escape_sh_string($script_path);
        "$bin_path_escaped \$ROONDA_TMP_PATH/$script_path_escaped";
    } else {
        unshift(@list, $head);
        eat_list_sh_command_normal(\@list);
    }
}

sub eat_list_sh_pipe {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_sh_command($head);
        $result = $result . ' | ' if ($result);
        $result = $result . $source;
    }
}

sub eat_list_sh_command_normal {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_sh_argument($head);
        $result = $result . ' ' if ($result);
        $result = $result . $source;
    }
}

sub eat_token_sh_argument {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING || $type eq $TOKEN_TYPE_INTEGER) {
        escape_sh_string($token);
    } elsif ($type eq $TOKEN_TYPE_LIST) {
        eat_list_sh_argument($token);
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_sh_argument {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    unless (defined($head)) {
        return "''";
    }
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        if ($token eq 'backticks') {
            eat_list_sh_argument_backticks(\@list);
        } elsif ($token eq 'ref') {
            eat_list_sh_argument_ref(\@list);
        } elsif ($token eq 'strcat') {
            eat_list_sh_argument_strcat(\@list);
        } else {
            die "Unexpected token: `$token_str` (Line: $line_no)";
        }
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_sh_argument_backticks {
    my ($list_ref) = @_;
    my $source = eat_list_sh_command($list_ref);
    escape_sh_backticks($source);
}

sub eat_list_sh_argument_ref {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $head = shift(@list);
    die "Unexpected endo of list" unless (defined($head));
    my ($type, $line_no, $token, $token_str) = @$head;
    if ($type eq $TOKEN_TYPE_SYMBOL) {
        if (@list) {
            my $head = shift(@list);
            my ($type, $line_no, $token, $token_str) = @$head;
            die "Unexpected token: `$token_str` (Line: $line_no)";
        }
        '$' . $token;
    } else {
        die "Unexpected token: `$token_str` (Line: $line_no)";
    }
}

sub eat_list_sh_argument_strcat {
    my ($list_ref) = @_;
    my @list = @$list_ref;
    my $result = '';
    while () {
        my $head = shift(@list);
        unless (defined($head)) {
            return $result;
        }
        my $source = eat_token_sh_argument($head);
        $result = $result . $source;
    }
}

