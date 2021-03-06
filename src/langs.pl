
my %bin_path_map = ();

# return: ($bin_path, $bin_path_for_sh, $ext)
sub lang_to_bin_path {
    my ($lang) = @_;
    if ($lang eq $LANG_SEXPR) {
        ($ENV{$ENV_SELF_PATH}, undef, 'rd');
    } elsif ($lang eq $LANG_SH) {
        ('/bin/sh', 'sh', 'sh');
    } elsif ($lang eq $LANG_PERL) {
        (_get_cmd_path('perl'), 'perl', 'pl');
    } elsif ($lang eq $LANG_RUBY) {
        (_get_cmd_path('ruby'), 'ruby', 'rb');
    } elsif ($lang eq $LANG_PYTHON2) {
        (_get_cmd_path('python2'), 'python2', 'py');
    } elsif ($lang eq $LANG_PYTHON3) {
        (_get_cmd_path('python3'), 'python3', 'py');
    } elsif ($lang eq $LANG_PHP) {
        (_get_cmd_path('php'), 'php', 'php');
    } else {
        (undef, undef, undef);
    }
}

sub _get_cmd_path {
    my ($cmd) = @_;
    if (defined($bin_path_map{$cmd})) {
        return $bin_path_map{$cmd};
    }
    my $path = `sh -c "which $cmd"`;
    $path =~ s/\A(.*)\s*\z/$1/;
    unless ($path) {
        die "Command not found: $cmd";
    }
    $bin_path_map{$cmd} = $path;
    $path;
}

sub get_source_header {
    my ($lang, $ver) = @_;
    if ($lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3) {
        "import sys\n\n";
    } elsif ($lang eq $LANG_PHP) {
        "<?php\n\n";
    } elsif ($lang eq $LANG_PERL) {
        "use Encode qw/encode/;\n" .
        "use Data::Dumper;\n" .
        "\n"; # TODO 暫定
    } else {
        '';
    }
}

sub get_source_indent {
    my ($lang, $ver) = @_;
    if ($lang eq $LANG_RUBY) {
        "  ";
    } else {
        "    ";
    }
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
    } elsif ($str eq 'sh') {
        $LANG_SH;
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

sub is_lang_support {
    my ($lang, $ver) = @_;
    if ($lang eq $LANG_SH ||
        $ver >= 2 && ($lang eq $LANG_PERL ||
                      $lang eq $LANG_RUBY ||
                      $lang eq $LANG_PYTHON2 || $lang eq $LANG_PYTHON3 ||
                      $lang eq $LANG_PHP)) {
        1;
    } else {
        '';
    }
}

