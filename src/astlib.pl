
sub create_dying_msg_unexpected {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    "Unexpected token: `$token_str` (Line: $line_no)";
}

sub create_dying_msg_unexpected_closing {
    my ($close_line_no) = @_;
    "Unexpected token: `)` (Line: $close_line_no)";
}

sub astlib_is_list {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        1;
    } else {
        '';
    }
}

sub astlib_get_list {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        $token;
    } else {
        die;
    }
}

sub astlib_get_close_line_no {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_LIST) {
        $line_no_2;
    } else {
        die;
    }
}

sub astlib_is_symbol_or_string {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        1;
    } else {
        '';
    }
}

sub astlib_is_symbol {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL) {
        1;
    } else {
        '';
    }
}

sub astlib_is_string {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_STRING) {
        1;
    } else {
        '';
    }
}

sub astlib_get_symbol_or_string {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL || $type eq $TOKEN_TYPE_STRING) {
        $token;
    } else {
        die;
    }
}

sub astlib_get_symbol {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_SYMBOL) {
        $token;
    } else {
        die;
    }
}

sub astlib_get_string {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_STRING) {
        $token;
    } else {
        die;
    }
}

sub astlib_is_heredoc {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_HEREDOC) {
        1;
    } else {
        '';
    }
}

sub astlib_get_heredoc_name {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_HEREDOC) {
        $token;
    } else {
        die;
    }
}

sub astlib_get_heredoc_content {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_HEREDOC) {
        my $name = $token;
        get_saved_file($name);
    } else {
        die;
    }
}

sub astlib_is_integer {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_INTEGER) {
        1;
    } else {
        '';
    }
}

sub astlib_get_integer {
    my ($token_ref) = @_;
    my ($type, $line_no, $token, $token_str, $line_no_2) = @$token_ref;
    if ($type eq $TOKEN_TYPE_INTEGER) {
        $token;
    } else {
        die;
    }
}



