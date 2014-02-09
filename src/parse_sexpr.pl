
sub parse_sexpr {
    my ($lines, $ver) = @_;
    my @lines = @$lines;
    my ($lines_ref, $fname_map_ref) = _parse_sexpr_get_heredoc(@lines);
    @lines = @$lines_ref;
    my @tokens = ();
    my $line_no = 1;
    foreach my $line (@lines) {
        push(@tokens, _parse_sexpr_line($line, $line_no, $fname_map_ref));
        $line_no++;
    }
    push(@tokens, _parse_sexpr_eof($line_no));
    build_ast(\@tokens);
}

sub _parse_sexpr_get_heredoc {
    my @lines = @_;
    my @new_lines = ();
    my %fname_map = ();
    my $heredoc = '';
    my $heredoc_content = '';
    foreach my $line (@lines) {
        if ($heredoc) {
            if ($line =~ ('\A' . quotemeta($heredoc) . '\s*>>\s*\Z')) {
                my $ext = '';
                my $name;
                if ($heredoc =~ /\A(.+)\.([-_a-zA-Z0-9]+)\Z/) {
                    $name = $1;
                    $ext = $2;
                }
                my $fname = save_file($heredoc_content, $ext, 1, $name);
                $fname_map{$heredoc} = $fname;
                push(@new_lines, "\n");
                $heredoc = '';
                $heredoc_content = '';
                next;
            }
            $heredoc_content .= $line;
            push(@new_lines, "\n");
            next;
        }
        if ($line =~ /\A<<\s*([-+*\/._a-zA-Z0-9]+)\s*\Z/) {
            $heredoc = $1;
            push(@new_lines, "\n");
            next;
        }
        if ($line =~ /\A\s*\#/) {
            push(@new_lines, "\n");
            next;
        }
        push(@new_lines, $line);
    }
    (\@new_lines, \%fname_map);
}

sub _parse_sexpr_line {
    my ($line, $line_no, $fname_map_ref) = @_;
    my @tokens = ();
    while () {
        my $f = ($line =~ ('\A\s*(' . '\(' . '|' .
                                      '\)' . '|' .
                                      '0' . '|' .
                                      '-?[1-9][0-9]*' . '|' .
                                      '"(([^"\\\\]|\\\\[nrt"u])*)"' . '|' .
                                      ':[^ ]+' . '|' .
                                      '<' . '|' .
                                      '>' . '|' .
                                      '[-+*/._a-zA-Z0-9]+' .
                           ')'));
        unless ($f) {
            die "Unknown token: $line (Line: $line_no)" if ($line !~ /\A\s*\Z/);
            last;
        }
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
            $token = unescape_sexpr_string($1);
            $token_type = $TOKEN_TYPE_STRING;
        } elsif ($token =~ /\A:(.+)\Z/) {
            $token = $1;
            $token_type = $TOKEN_TYPE_SYMBOL;
        } else {
            $token_type = $TOKEN_TYPE_SYMBOL;
        }
        if ($token_type eq $TOKEN_TYPE_SYMBOL) {
            if (defined($fname_map_ref->{$token})) {
                $token = $fname_map_ref->{$token};
                $token_type = $TOKEN_TYPE_HEREDOC;
            }
        }
        push(@tokens, [$token_type, $line_no, $token, $token_str]);
    }
    @tokens;
}

sub _parse_sexpr_eof {
    my ($line_no) = @_;
    my @tokens = ();
    push(@tokens, [$TOKEN_TYPE_EOF, $line_no, 'EOF', 'EOF']);
    @tokens;
}

