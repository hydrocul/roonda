
sub gent_embed_simple_obj {
    my ($format_from, $lang, $ver) = @_;
    _embed_get_obj($format_from, $lang, $ver);
}

sub _embed_get_obj {
    my ($format_from, $lang_to, $ver) = @_;
    my @lines = <>;
    @lines = map { decode('utf-8', $_) } @lines;
    my $ast;
    if ($format_from eq $FORMAT_SEXPR) {
        $ast = parse_sexpr(\@lines, $ver);
    } elsif ($format_from eq $FORMAT_JSON) {
        $ast = parse_json(\@lines, $ver);
    } else {
        die "Unknown embedded object format: $format_from";
    }
    my $source = gent_obj($ast, $lang_to, $ver);
    $source;
}



