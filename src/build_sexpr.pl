
sub build_sexpr {
    my ($tokens_ref) = @_;
    my @tokens = @$tokens_ref;
    my ($sexpr, $tail_tokens_ref) = _build_sexpr_list(0, \@tokens);
    @tokens = @$tail_tokens_ref;
    if (@tokens) {
        my $head = shift(@tokens);
        my ($type, $line_no, $token, $token_str) = @$head;
        die "Unexpected token: `$token_str` (Line: $line_no), but expected <EOF>";
    }
    $sexpr;
}

sub _build_sexpr_list {
    my ($list_line_no, $tokens_ref) = @_;
    my @tokens = @$tokens_ref;
    my @result = ();
    while () {
        my $head = shift(@tokens);
        unless (defined($head)) {
            return ([$TOKEN_TYPE_LIST, $list_line_no, \@result, '('], \@tokens);
        }
        my ($type, $line_no, $token, $token_str) = @$head;
        if ($type eq $TOKEN_TYPE_OPEN) {
            my ($sexpr, $tail_tokens_ref) = _build_sexpr_list($line_no, \@tokens);
            push(@result, $sexpr);
            @tokens = @$tail_tokens_ref;
        } elsif ($type eq $TOKEN_TYPE_CLOSE) {
            return ([$TOKEN_TYPE_LIST, $list_line_no, \@result, '('], \@tokens);
        } else {
            push(@result, $head);
        }
    }
}


