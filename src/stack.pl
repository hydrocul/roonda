
sub istack_create {
    ['', 0, '', {}, undef];
}

sub istack_get_indent {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $vars, $prev) = @$istack;
    $indent;
}

sub istack_append_indent {
    my ($istack, $append) = @_;
    my ($lang, $ver, $indent, $vars, $prev) = @$istack;
    [$lang, $ver, $indent . $append, $vars, $prev];
}

sub istack_var_exists {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $vars, $prev) = @$istack;
    if (defined($vars->{$varname})) {
        1;
    } else {
        '';
    }
}

sub istack_perl_var_is_scalar {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $vars, $prev) = @$istack;
    # die if ($lang ne $LANG_PERL); # TODO istack
    if (!defined($vars->{$varname})) {
        '';
    } elsif ($vars->{$varname} eq 'scalar') {
        1;
    } else {
        '';
    }
}

sub istack_perl_var_declare_scalar {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $vars, $prev) = @$istack;
    # die if ($lang ne $LANG_PERL); # TODO istack
    my %new_vars = %$vars;
    $new_vars{$varname} = 'scalar';
    [$lang, $ver, $indent, \%new_vars, $prev];
}

sub ostack_create {
    [];
}

