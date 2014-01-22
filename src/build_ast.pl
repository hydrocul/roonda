
sub build_ast {
    my ($tokens_ref) = @_;
    my @tokens = @$tokens_ref;
    my ($sexpr, $tail_tokens_ref) = _build_ast_list(0, \@tokens);
    @tokens = @$tail_tokens_ref;
    if (@tokens) {
        my $head = shift(@tokens);
        my ($type, $line_no, $token, $token_str) = @$head;
        unless ($type eq $TOKEN_TYPE_EOF) {
            die "Unexpected token: `$token_str` (Line: $line_no), but expected <EOF>";
        }
    }
    $sexpr;
}

sub _build_ast_list {
    my ($list_line_no, $tokens_ref) = @_;
    my @tokens = @$tokens_ref;
    my @result = ();
    while () {
        my $head = shift(@tokens);
        my ($type, $line_no, $token, $token_str) = @$head;
        if ($type eq $TOKEN_TYPE_OPEN) {
            my ($sexpr, $tail_tokens_ref) = _build_ast_list($line_no, \@tokens);
            push(@result, $sexpr);
            @tokens = @$tail_tokens_ref;
        } elsif ($type eq $TOKEN_TYPE_CLOSE) {
            return ([$TOKEN_TYPE_LIST, $list_line_no, \@result, '(', $line_no], \@tokens);
        } elsif ($type eq $TOKEN_TYPE_EOF) {
            unshift(@tokens, $head);
            return ([$TOKEN_TYPE_LIST, $list_line_no, \@result, '(', $line_no], \@tokens);
        } else {
            push(@result, [$type, $line_no, $token, $token_str, 0]);
        }
    }
}


