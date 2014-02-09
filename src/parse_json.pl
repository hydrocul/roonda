
sub parse_json {
    my ($lines, $ver) = @_;
    my @lines = @$lines;
    my $json_src = join('', @lines);
    my $json_data = decode_json($json_src);
    _parse_json_add_meta($json_data);
}

sub _parse_json_add_meta {
    my ($json_data) = @_;
    if (ref $json_data eq 'ARRAY') {
        if ($json_data->[0] eq 'string') {
            [$TOKEN_TYPE_STRING, 0, $json_data, $json_data, 0];
        } else {
            my @result = ();
            foreach my $elem (@$json_data) {
                push(@result, _parse_json_add_meta($elem));
            }
            [$TOKEN_TYPE_LIST, 0, \@result, '(', 0];
        }
    } elsif (ref $json_data eq 'HASH') {
        die; # TODO
    } elsif (ref $json_data ne '') {
        die $json_data;
    } else {
        if (JSON::is_bool($json_data)) {
            # boolean
            if ($json_data) {
                [$TOKEN_TYPE_SYMBOL, 0, 'true', 'true', 0];
            } else {
                [$TOKEN_TYPE_SYMBOL, 0, 'false', 'false', 0];
            }
        } elsif ( ($json_data ^ $json_data) eq '0' ){ # ref http://anond.hatelabo.jp/20080303125703
            # numeric
            [$TOKEN_TYPE_INTEGER, 0, $json_data, $json_data, 0];
        } else {
            # string
            [$TOKEN_TYPE_SYMBOL, 0, $json_data, $json_data, 0];
        }
    }
}

