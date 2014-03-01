
# return: ($source, $istack)
sub genl_if {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    my $cond_istack = st_if_cond_stack($istack, $lang, $ver);
    my $then_istack = st_if_then_else_stack($istack, $lang, $ver);
    my $then_indent = istack_get_indent($then_istack);
    my @list = @$list;
    my $cond_elem = shift(@list);
    unless (defined($cond_elem)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $then_elem = shift(@list);
    unless (defined($then_elem)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $else_elem = shift(@list);
    if (@list) {
        die create_dying_msg_unexpected(shift(@list));
    }
    my $if_indent = istack_get_indent($istack);

    my $cond_source;
    if ($lang eq $LANG_SH) {
        ($cond_source, $cond_istack)  =
            gent_sh_command($cond_elem, '', '', '', 1, '', 1, 1, $istack, $ver);
    } else {
        ($cond_source, $cond_istack) =
            gent_expr($cond_elem, $OP_ORDER_MIN, $cond_istack, $lang, $ver);
    }
    my $then_source;
    ($then_source, $then_istack) =
        gent_stmt_statements($then_elem, $then_istack, $lang, $ver);
    my $else_source;
    if (defined($else_elem)) {
        my $else_istack = $then_istack;
        ($else_source, $else_istack) =
            gent_stmt_statements($else_elem, $else_istack, $lang, $ver);
        $istack = st_if_result($istack, $cond_istack, $then_istack, $else_istack, $lang, $ver);
    } else {
        $istack = st_if_result($istack, $cond_istack, $then_istack, undef, $lang, $ver);
    }
    (_gent_if_sub($cond_source, $then_source, $else_source, $if_indent, $then_indent, $lang), $istack);
}

# return: $source
sub _gent_if_sub {
    my ($cond_source, $then_source, $else_source, $if_indent, $then_indent, $lang) = @_;
    if ($lang eq $LANG_SH) {
        if (defined($else_source)) {
            "if $cond_source; then\n" .
            "$then_indent$then_source\n" .
            "${if_indent}else\n" .
            "$then_indent$else_source\n" .
            "${if_indent}fi";
        } else {
            "if $cond_source; then\n" .
            "$then_indent$then_source\n" .
            "${if_indent}fi";
        }
    } elsif ($lang eq $LANG_PERL) {
        if (defined($else_source)) {
            "if ($cond_source) {\n" .
            "$then_indent$then_source\n" .
            "$if_indent} else {\n" .
            "$then_indent$else_source\n" .
            "$if_indent}";
        } else {
            "if ($cond_source) {\n" .
            "$then_indent$then_source\n" .
            "$if_indent}";
        }
    } elsif ($lang eq $LANG_RUBY) {
        if (defined($else_source)) {
            "if $cond_source\n" .
            "$then_indent$then_source\n" .
            "${if_indent}else\n" .
            "$then_indent$else_source\n" .
            "${if_indent}end";
        } else {
            "if $cond_source\n" .
            "$then_indent$then_source\n" .
            "${if_indent}end";
        }
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        if (defined($else_source)) {
            "if $cond_source:\n" .
            "$then_indent$then_source\n" .
            "${if_indent}else:\n" .
            "$then_indent$else_source";
        } else {
            "if $cond_source:\n" .
            "$then_indent$then_source";
        }
    } elsif ($lang eq $LANG_PHP) {
        if (defined($else_source)) {
            "if ($cond_source) {\n" .
            "$then_indent$then_source\n" .
            "$if_indent} else {\n" .
            "$then_indent$else_source\n" .
            "$if_indent}";
        } else {
            "if ($cond_source) {\n" .
            "$then_indent$then_source\n" .
            "$if_indent}";
        }
    } else {
        die;
    }
}

sub st_if_cond_stack {
    my ($istack, $lang, $ver) = @_;
    istack_append_indent($istack, get_source_indent($lang, $ver));
    # TODO ruby, python, php
}

sub st_if_then_else_stack {
    my ($istack, $lang, $ver) = @_;
    istack_append_indent($istack, get_source_indent($lang, $ver));
    # TODO ruby, python, php
}

sub st_if_result {
    my ($parent_istack, $cond_istack, $then_istack, $else_istack, $lang, $ver) = @_;
    if ($lang eq $LANG_PERL) {
        st_perl_if_result($parent_istack, $cond_istack, $then_istack, $else_istack, $ver);
    } else {
        $parent_istack;
    }
    # TODO ruby, python, php
}

sub st_perl_if_result {
    my ($parent_istack, $cond_istack, $then_istack, $else_istack) = @_;
    $parent_istack = st_perl_report_use_utf8($parent_istack, $cond_istack);
    $parent_istack = st_perl_report_use_utf8($parent_istack, $then_istack);
    if (defined($else_istack)) {
        $parent_istack = st_perl_report_use_utf8($parent_istack, $else_istack);
    }
    $parent_istack;
    # TODO ruby, python, php
}

