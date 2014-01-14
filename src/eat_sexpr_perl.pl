
sub eat_list_exec_perl {
    my ($bin_path, $lang_opts_ref, $list_ref) = @_;
    unless (defined($bin_path)) {
        $bin_path = '/bin/perl';
    }
    ($bin_path, "print \"Hello world!\\n\";\n");
}

