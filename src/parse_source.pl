
sub parse_source {
    my @lines = @_;
    my @tokens = ();
    my $line_no = 1;
    foreach my $line (@lines) {
        push(@tokens, _parse_source_line($line, $line_no));
        $line_no++;
    }
    # push(@tokens, _parse_source_eof($line_no);
    \@tokens;
}

sub _parse_source_line {
    my ($line, $line_no) = @_;
    my @tokens = ();
    while ($line =~ ('\A\s*(' . '\(' . '|' .
                                '\)' . '|' .
                                '0' . '|' .
                                '-?[1-9][0-9]*' . '|' .
                                '"(([^"\\\\]|\\\\[nrt"u])*)"' . '|' .
                                ':[^ ]+' . '|' .
                                '\+' . '|' .
                                '-' . '|' .
                                '[-*]*[_a-zA-Z]([-_a-zA-Z0-9]*[_a-zA-Z0-9])?' .
                     ')')) {
        my $token = $1;
        my $token_str = $token;
        my $token_type;
        $line = ${^POSTMATCH};
        if ($token eq '(') {
            $token_type = $TOKEN_TYPE_OPEN;
        } elsif ($token eq ')') {
            $token_type = $TOKEN_TYPE_CLOSE;
        } elsif ($token eq '0') {
            $token = 0;
            $token_type = $TOKEN_TYPE_INTEGER;
        } elsif ($token =~ /\A-?[1-9][0-9]*\Z/) {
            $token = $token + 0; # convert to integer
            $token_type = $TOKEN_TYPE_INTEGER;
        } elsif ($token =~ /\A"(.*)"\Z/) {
            my $str = $1;
            $str =~ s/\\n/\n/g;
            $str =~ s/\\r/\r/g;
            $str =~ s/\\t/\t/g;
            $str =~ s/\\"/"/g;
            $str =~ s/\\u([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])/chr(hex($1))/ge;
            $token = $str;
            $token_type = $TOKEN_TYPE_STRING;
        } elsif ($token =~ /\A:(.+)\Z/) {
            $token = $1;
            $token_type = $TOKEN_TYPE_SYMBOL;
        } else {
            $token_type = $TOKEN_TYPE_SYMBOL;
        }
        push(@tokens, [$token_type, $line_no, $token, $token_str]);
    }
    if ($line !~ /\A\s*\Z/) {
        die "Unknown token: $line (Line: $line_no)";
    }
    @tokens;
}

=comment
sub _parse_source_eof {
    my ($line, $line_no) = @_;
    my @tokens = ();
    push(@tokens, [$TOKEN_TYPE_EOF, $line_no, 'EOF', 'EOF']);
    @tokens;
}
=cut

