
sub istack_create {
    my ($lang, $ver) = @_;
    [$lang, $ver, '', {}, undef];
}

sub istack_get_indent {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    $indent;
}

sub istack_append_indent {
    my ($istack, $append) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    [$lang, $ver, $indent . $append, $info, $prev];
}

