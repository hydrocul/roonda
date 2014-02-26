
sub istack_create {
    my ($lang, $ver) = @_;
    [$lang, $ver, '', {}, {}, undef];
}

sub istack_get_indent {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    $indent;
}

sub istack_append_indent {
    my ($istack, $append) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    [$lang, $ver, $indent . $append, $vars, $global_info, $prev];
}

sub istack_perl_finish_scope {
    my ($parent_istack, $child_istack) = @_;
    if (istack_perl_needs_use_utf8($child_istack)) {
        $parent_istack = istack_perl_set_string_use_utf8($parent_istack);
    }
    $parent_istack;
}

sub istack_perl_var_exists {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    if (defined($vars->{$varname})) {
        1;
    } else {
        '';
    }
}

sub istack_perl_var_is_scalar {
    my ($istack, $varname) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
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
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    my %new_vars = %$vars;
    $new_vars{$varname} = 'scalar';
    [$lang, $ver, $indent, \%new_vars, $prev];
}

sub istack_perl_needs_use_utf8 {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    if (!$global_info->{declare_use_utf8} && $global_info->{string_use_utf8}) {
        1;
    } else {
        '';
    }
}

sub istack_perl_declare_use_utf8 {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    my %new_global_info = %$global_info;
    $new_global_info{declare_use_utf8} = 1;
    [$lang, $ver, $indent, $vars, \%new_global_info, $prev];
}

sub istack_perl_check_string_utf8 {
    my ($istack, $str) = @_;
    if (exists_perl_wide_char($str)) {
        istack_perl_set_string_use_utf8($istack);
    } else {
        $istack;
    }
}

sub istack_perl_set_string_use_utf8 {
    my ($istack) = @_;
    my ($lang, $ver, $indent, $vars, $global_info, $prev) = @$istack;
    die if ($lang ne $LANG_PERL);
    if ($global_info->{string_use_utf8}) {
        $istack;
    } else {
        my %new_global_info = %$global_info;
        $new_global_info{string_use_utf8} = 1;
        [$lang, $ver, $indent, $vars, \%new_global_info, $prev];
    }
}

sub ostack_create {
    [];
}

