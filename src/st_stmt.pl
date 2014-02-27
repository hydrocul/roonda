
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

