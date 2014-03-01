
# return: ($source, $istack)
sub genl_print {
    my ($list, $list_close_line_no, $istack, $lang, $ver) = @_;
    die unless (defined($istack));
    die if ($lang eq $LANG_SEXPR);
    my @list = @$list;
    my $elem = shift(@list);
    die create_dying_msg_unexpected_closing($list_close_line_no) unless (defined($elem));
    my $source;
    if ($lang eq $LANG_SH) {
        my $_istack;
        ($source, $_istack) = gent_sh_argument($elem, $istack, $ver);
    } else {
        ($source, $istack) = gent_expr($elem, $OP_ORDER_ARG_COMMA, $istack, $lang, $ver);
    }
    if ($lang eq $LANG_SH) {
        ("echo -n $source", $istack);
    } elsif ($lang eq $LANG_PERL) {
        ("print encode('utf-8', $source)", $istack);
    } elsif ($lang eq $LANG_RUBY) {
        ("print $source", $istack);
    } elsif ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        ("sys.stdout.write(str($source))", $istack);
    } elsif ($lang eq $LANG_PHP) {
        ("echo $source", $istack);
    } else {
        die;
    }
}

