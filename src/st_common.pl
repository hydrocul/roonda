
sub istack_create {
    my ($lang, $ver) = @_;
    {lang => $lang, ver => $ver, indent => '', vars => {}, prev => undef}
}

sub istack_get_indent {
    my ($istack) = @_;
    $istack->{indent}
}

sub istack_append_indent {
    my ($istack, $append) = @_;
    my %new_istack = %$istack;
    $new_istack{indent} = $istack->{indent} . $append;
    \%new_istack;
}

sub istack_sub_get_var_info {
    my ($istack, $varname) = @_;
    $istack->{vars}->{$varname}
}

sub istack_sub_set_var_info {
    my ($istack, $varname, $info) = @_;
    my %new_vars = %{$istack->{vars}};
    $new_vars{$varname} = $info;
    my %new_istack = %$istack;
    $new_istack{vars} = \%new_vars;
    \%new_istack;
}
