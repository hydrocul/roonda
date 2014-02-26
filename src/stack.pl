
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

sub istack_if_cond_stack {
    my ($istack, $lang, $ver) = @_;
    if ($lang eq $LANG_PERL) {
        istack_perl_if_cond_stack($istack, $ver);
    } else {
        istack_append_indent($istack, get_source_indent($lang, $ver)); # TODO istack
    }
}

sub istack_if_then_else_stack {
    my ($istack, $lang, $ver) = @_;
    if ($lang eq $LANG_PERL) {
        istack_perl_if_then_else_stack($istack, $ver);
    } else {
        istack_append_indent($istack, get_source_indent($lang, $ver)); # TODO istack
    }
}

sub istack_if_result {
    my ($parent_istack, $cond_istack, $then_istack, $else_istack, $lang, $ver) = @_;
    if ($lang eq $LANG_PERL) {
        istack_perl_if_result($parent_istack, $cond_istack, $then_istack, $else_istack, $ver);
    } else {
        $parent_istack; # TODO istack
    }
}

sub istack_perl_if_cond_stack {
    my ($istack, $ver) = @_;
    istack_append_indent($istack, get_source_indent($LANG_PERL, $ver));
}

sub istack_perl_if_then_else_stack {
    my ($istack, $ver) = @_;
    istack_append_indent($istack, get_source_indent($LANG_PERL, $ver));
}

sub istack_perl_if_result {
    my ($parent_istack, $cond_istack, $then_istack, $else_istack) = @_;
    $parent_istack = _istack_perl_report_use_utf($parent_istack, $cond_istack);
    $parent_istack = _istack_perl_report_use_utf($parent_istack, $then_istack);
    if (defined($else_istack)) {
        $parent_istack = _istack_perl_report_use_utf($parent_istack, $else_istack);
    }
    $parent_istack;
}

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

