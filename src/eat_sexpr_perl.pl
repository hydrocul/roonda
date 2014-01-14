
sub eat_list_exec_perl {
    my ($bin_path, $lang_opts_ref, $list_ref) = @_;
    unless (defined($bin_path)) {
        $bin_path = '/usr/bin/perl';
    }
    ($bin_path, eat_list_langs($list_ref, $LANG_PERL));
}

