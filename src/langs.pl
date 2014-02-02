
my %bin_path_map = ();

# return: $bin_path, $ext
sub lang_to_bin_path {
    my ($lang) = @_;
    if ($lang eq $LANG_SEXPR) {
        ($ENV{$ENV_SELF_PATH}, 'rd');
    } elsif ($lang eq $LANG_SH) {
        ('/bin/sh', 'sh');
    } elsif ($lang eq $LANG_PERL) {
        (_get_cmd_path('perl'), 'pl');
    } elsif ($lang eq $LANG_RUBY) {
        (_get_cmd_path('ruby'), 'rb');
    } elsif ($lang eq $LANG_PYTHON2) {
        (_get_cmd_path('python2'), 'py');
    } elsif ($lang eq $LANG_PYTHON3) {
        (_get_cmd_path('python3'), 'py');
    } else {
        die;
    }
}

sub bin_path_to_lang {
    my ($bin_path) = @_;
    if ($bin_path =~ /\/sh\Z/) {
        ($LANG_SH, $bin_path, $bin_path, 'sh');
    } elsif ($bin_path eq 'sh') {
        ($LANG_SH, '/bin/sh', 'sh', 'sh');
    } elsif ($bin_path =~ /\/perl\Z/) {
        ($LANG_PERL, $bin_path, $bin_path, 'pl');
    } elsif ($bin_path eq 'perl') {
        ($LANG_PERL, _get_cmd_path('perl'), 'perl', 'pl');
    } elsif ($bin_path =~ /\/ruby\Z/) {
        ($LANG_RUBY, $bin_path, $bin_path, 'rb');
    } elsif ($bin_path eq 'ruby') {
        ($LANG_RUBY, _get_cmd_path('ruby'), 'ruby', 'rb');
    } elsif ($bin_path =~ /\/python2\Z/) {
        ($LANG_PYTHON2, $bin_path, $bin_path, 'py');
    } elsif ($bin_path eq 'python2') {
        ($LANG_PYTHON2, _get_cmd_path('python2'), 'python2', 'py');
    } elsif ($bin_path =~ /\/python3\Z/) {
        ($LANG_PYTHON3, $bin_path, $bin_path, 'py');
    } elsif ($bin_path eq 'python3') {
        ($LANG_PYTHON3, _get_cmd_path('python3'), 'python2', 'py');
    } else {
        (undef, undef, undef, undef);
    }
}

sub _get_cmd_path {
    my ($cmd) = @_;
    if (defined($bin_path_map{$cmd})) {
        return $bin_path_map{$cmd};
    }
    my $path = `sh -c "which $cmd"`;
    $path =~ s/\A(.*)\s*\Z/$1/;
    unless ($path) {
        die "Command not found: $cmd";
    }
    $bin_path_map{$cmd} = $path;
    $path;
}

sub get_src_format_label {
    my ($str) = @_;
    if ($str eq 'sexpr') {
        $FORMAT_SEXPR;
    } elsif ($str eq 'json') {
        $FORMAT_JSON;
    } else {
        undef;
    }
}

sub get_dst_format_label {
    my ($str) = @_;
    if ($str eq 'sexpr') {
        $LANG_SEXPR;
    } elsif ($str eq 'perl') {
        $LANG_PERL;
    } elsif ($str eq 'ruby') {
        $LANG_RUBY;
    } elsif ($str eq 'python2') {
        $LANG_PYTHON2;
    } elsif ($str eq 'python3') {
        $LANG_PYTHON3;
    } elsif ($str eq 'php') {
        $LANG_PHP;
    } else {
        undef;
    }
}

