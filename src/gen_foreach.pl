
# return: ($source, $istack)
sub genl_foreach {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    die if ($lang eq $LANG_SH);
    my $indent = istack_get_indent($istack);
    my $list_istack = st_foreach_list_stack($istack, $lang, $ver);
    my @list = @$list;
    my $varname_token = shift(@list);
    my $varname;
    if (astlib_is_symbol($varname_token)) {
        $varname = astlib_get_symbol($varname_token);
    } else {
        die create_dying_msg_unexpected($varname_token);
    }
    my $list_token = shift(@list);
    unless (defined($list_token)) {
        die create_dying_msg_unexpected_closing($list_close_line_no);
    }
    my $list_source;
    ($list_source, $list_istack) =
        gent_expr($list_token, $OP_ORDER_MIN, $list_istack, $lang, $ver);
    my $body_istack = st_foreach_body_stack($varname, $istack, $lang, $ver);
    my $body_indent = istack_get_indent($body_istack);
    my $body_source;
    ($body_source, $body_istack) =
        genl_stmt_statements(\@list, $list_close_line_no, $body_istack, $lang, $ver);
    $istack = st_foreach_result($istack, $list_istack, $body_istack, $lang, $ver);
    (_gent_foreach_sub($varname, $list_source, $body_source, $indent, $body_indent, $lang), $istack);
}

# return: $source
sub _gent_foreach_sub {
    my ($varname, $list_source, $body_source, $indent, $body_indent, $lang) = @_;
    if ($lang eq $LANG_PERL) {
        "foreach my \$$varname (\@{$list_source}) {\n" .
        "$body_indent$body_source\n" .
        "$indent}";
    } elsif ($lang eq $LANG_RUBY) {
        "for $varname in $list_source do\n" .
        "$body_indent$body_source\n" .
        "${indent}end";
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        "for $varname in $list_source:\n" .
        "$body_indent$body_source";
    } elsif ($lang eq $LANG_PHP) {
        "foreach ($list_source as \$$varname) {\n" .
        "$body_indent$body_source\n" .
        "$indent}";
    } else {
        die;
    }
}

sub st_foreach_list_stack {
    my ($istack, $lang, $ver) = @_;
    istack_append_indent($istack, get_source_indent($lang, $ver));
}

sub st_foreach_body_stack {
    my ($varname, $istack, $lang, $ver) = @_;
    $istack = istack_append_indent($istack, get_source_indent($lang, $ver));
    if ($lang eq $LANG_PERL) {
        $istack = st_var_perl_declare_scalar($istack, $varname);
    } elsif ($lang eq $LANG_RUBY) {
        $istack = st_var_ruby_declare($istack, $varname);
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        $istack = st_var_python_declare($istack, $varname);
    } elsif ($lang eq $LANG_PHP) {
        $istack = st_var_php_declare($istack, $varname);
    } else {
        die;
    }
}

sub st_foreach_result {
    my ($parent_istack, $list_istack, $body_istack, $lang, $ver) = @_;
    $parent_istack;
    # TODO perl, ruby, python, php
}

