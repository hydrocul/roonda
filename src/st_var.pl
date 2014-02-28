
sub istack_var_sh_exists {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_SH);
    if (!defined($info->{vars})) {
        '';
    } elsif (defined($info->{vars}->{$varname})) {
        1;
    } else {
        '';
    }
}

sub istack_var_sh_declare_shell {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_SH);
    my %new_info = %$info;
    my %new_vars;
    if ($new_info{vars}) {
        %new_vars = %{$new_info{vars}};
    } else {
        %new_vars = ();
    }
    $new_vars{$varname} = 'shell';
    $new_info{vars} = \%new_vars;
    [$lang, $ver, $indent, \%new_info, $prev];
}

sub istack_var_perl_exists {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    if (!defined($info->{vars})) {
        '';
    } elsif (defined($info->{vars}->{$varname})) {
        1;
    } else {
        '';
    }
}

sub istack_var_perl_is_scalar {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    if (!defined($info->{vars})) {
        '';
    } elsif ($info->{vars}->{$varname} eq 'scalar') {
        1;
    } else {
        '';
    }
}

sub istack_var_perl_declare_scalar {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    my %new_info = %$info;
    my %new_vars;
    if ($new_info{vars}) {
        %new_vars = %{$new_info{vars}};
    } else {
        %new_vars = ();
    }
    $new_vars{$varname} = 'scalar';
    $new_info{vars} = \%new_vars;
    [$lang, $ver, $indent, \%new_info, $prev];
}

