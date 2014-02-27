
sub _istack_perl_report_use_utf {
    my ($parent_istack, $child_istack) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$child_istack;
    die if ($lang ne $LANG_PERL);
    if ($info->{string_use_utf8}) {
        my ($p_lang, $p_ver, $p_indent, $p_info, $p_prev) = @$parent_istack;
        my %new_info = %$p_info;
        $new_info{string_use_utf8} = 1;
        $parent_istack = [$p_lang, $p_ver, $p_indent, \%new_info, $p_prev];
    }
    $parent_istack;
}

sub istack_perl_needs_use_utf8 {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    if (!$info->{declare_use_utf8} && $info->{string_use_utf8}) {
        1;
    } else {
        '';
    }
}

sub istack_perl_declare_use_utf8 {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    my %new_info = %$info;
    $new_info{declare_use_utf8} = 1;
    [$lang, $ver, $indent, \%new_info, $prev];
}

sub istack_perl_check_string_utf8 {
    my ($istack, $str) = @_;
    if (exists_perl_wide_char($str)) {
        my ($lang, $ver, $indent, $info, $prev) = @$istack;
        die if ($lang ne $LANG_PERL);
        my %new_info = %$info;
        $new_info{string_use_utf8} = 1;
        [$lang, $ver, $indent, \%new_info, $prev];
    } else {
        $istack;
    }
}

sub istack_perl_var_exists {
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

sub istack_perl_var_is_scalar {
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

sub istack_perl_var_declare_scalar {
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

