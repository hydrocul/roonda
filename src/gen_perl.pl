
sub st_perl_report_use_utf8 {
    my ($parent_istack, $child_istack) = @_;
    die if ($parent_istack->{lang} ne $LANG_PERL);
    if ($child_istack->{string_use_utf8}) {
        my %new_istack = %$parent_istack;
        $new_istack{string_use_utf8} = 1;
        $parent_istack = \%new_istack;
    }
    $parent_istack;
}


sub st_perl_needs_use_utf8 {
    my ($istack) = @_;
    die if ($istack->{lang} ne $LANG_PERL);
    if (!$istack->{declare_use_utf8} && $istack->{string_use_utf8}) {
        1;
    } else {
        '';
    }
}

sub st_perl_declare_use_utf8 {
    my ($istack) = @_;
    die if ($istack->{lang} ne $LANG_PERL);
    my %new_istack = %$istack;
    $new_istack{declare_use_utf8} = 1;
    \%new_istack;
}

sub st_perl_check_string_utf8 {
    my ($istack, $str) = @_;
    if (exists_perl_wide_char($str)) {
        st_perl_set_needs_use_utf8($istack);
    } else {
        $istack;
    }
}

sub st_perl_set_needs_use_utf8 {
    my ($istack) = @_;
    die if ($istack->{lang} ne $LANG_PERL);
    my %new_istack = %$istack;
    $new_istack{string_use_utf8} = 1;
    \%new_istack;
}

