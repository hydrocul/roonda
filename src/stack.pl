
sub istack_create {
    ['', []];
}

sub istack_get_indent {
    my ($istack) = @_;
    my ($indent, $vars) = @$istack;
    $indent;
}

sub istack_append_indent {
    my ($istack, $append) = @_;
    my ($indent, $vars) = @$istack;
    [$indent . $append, $vars];
}

sub istack_new_var {
    my ($istack, $varname) = @_;
    my ($indent, $vars) = @$istack;
    my $new_vars = [@$vars, $varname];
    [$indent, $vars];
}

#sub ostack_create {
#    [];
#}


