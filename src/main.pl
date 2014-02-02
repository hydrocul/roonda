
my $type_from = '';
my $from_ver = '';
my $type_to = '';
my $to_lang = '';
my $to_ver = '';
my $is_dryrun = '';
my $replace_tag = '';
my $source_filepath = '';
my $template_source_filepath = '';
while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg eq '--from-sexpr') {
        die if ($type_from ne '');
        $type_from = 'sexpr';
    } elsif ($arg =~ /--from-json-(\d+)/) {
        die if ($type_from ne '');
        $type_from = 'json';
        $from_ver = $1;
    } elsif ($arg =~ /--sexpr-to-sexpr/) {
        die if ($type_from ne '');
        die if ($type_to ne '');
        $type_from = 'sexpr';
        $type_to = 'obj';
        $to_lang = $LANG_SEXPR;
    } elsif ($arg =~ /--sexpr-to-([a-z0-9]+)-(\d+)/) {
        die if ($type_from ne '');
        die if ($type_to ne '');
        $type_from = 'sexpr';
        $type_to = 'obj';
        if ($1 eq 'perl') {
            $to_lang = $LANG_PERL;
        } elsif ($1 eq 'ruby') {
            $to_lang = $LANG_RUBY;
        } elsif ($1 eq 'python2') {
            $to_lang = $LANG_PYTHON2;
        } elsif ($1 eq 'python3') {
            $to_lang = $LANG_PYTHON3;
        } else {
            die "Unknown argument: $arg";
        }
        $to_ver = $2;
    } elsif ($arg =~ /--([a-z0-9]+)-(\d+)-to-sexpr/) {
        die if ($type_from ne '');
        die if ($type_to ne '');
        if ($1 eq 'json') {
            $type_from = 'json';
        } else {
            die "Unknown argument: $arg";
        }
        $from_ver = $2;
        $type_to = 'obj';
        $to_lang = $LANG_SEXPR;
    } elsif ($arg =~ /--([a-z0-9]+)-(\d+)-to-([a-z0-9]+)-(\d+)/) {
        die if ($type_from ne '');
        die if ($type_to ne '');
        if ($1 eq 'json') {
            $type_from = 'json';
        } else {
            die "Unknown argument: $arg";
        }
        $from_ver = $2;
        $type_to = 'obj';
        if ($3 eq 'sexpr') {
            $to_lang = $LANG_SEXPR;
        } elsif ($3 eq 'perl') {
            $to_lang = $LANG_PERL;
        } elsif ($3 eq 'ruby') {
            $to_lang = $LANG_RUBY;
        } elsif ($3 eq 'python2') {
            $to_lang = $LANG_PYTHON2;
        } elsif ($3 eq 'python3') {
            $to_lang = $LANG_PYTHON3;
        } else {
            die "Unknown argument: $arg";
        }
        $to_ver = $4;
    } elsif ($arg =~ /--to-sexpr-obj/) {
        die if ($type_to ne '');
        $type_to = 'obj';
        $to_lang = $LANG_SEXPR;
    } elsif ($arg =~ /--to-perl-obj-(\d+)/) {
        die if ($type_to ne '');
        $type_to = 'obj';
        $to_lang = $LANG_PERL;
        $to_ver = $1;
    } elsif ($arg =~ /--to-ruby-obj-(\d+)/) {
        die if ($type_to ne '');
        $type_to = 'obj';
        $to_lang = $LANG_RUBY;
        $to_ver = $1;
    } elsif ($arg =~ /--to-python2-obj-(\d+)/) {
        die if ($type_to ne '');
        $type_to = 'obj';
        $to_lang = $LANG_PYTHON2;
        $to_ver = $1;
    } elsif ($arg =~ /--to-python3-obj-(\d+)/) {
        die if ($type_to ne '');
        $type_to = 'obj';
        $to_lang = $LANG_PYTHON3;
        $to_ver = $1;
    } elsif ($arg eq '--replace-tag') {
        my $arg2 = shift;
        unless (defined($arg2)) {
            die;
        }
        die if ($replace_tag ne '');
        $replace_tag = $arg2;
    } elsif ($arg eq '--output-code') {
        $is_dryrun = 1;
    } elsif ($arg =~ /\A-/) {
        die "Unknown argument: $arg";
    } else {
        if ($type_to eq 'obj') {
            die if ($template_source_filepath);
            $template_source_filepath = $arg;
        } else {
            die if ($source_filepath);
            $source_filepath = $arg;
        }
    }
}

if ($type_from eq '') {
    $type_from = 'sexpr';
}
if ($type_to eq '') {
    $type_to = 'exec';
}

if ($type_to eq 'obj' && $replace_tag ne '' && $template_source_filepath eq '') {
    die;
}
if ($type_to ne 'obj' && $replace_tag ne '') {
    die;
}

if ($type_to eq 'obj' && $replace_tag eq '' && $template_source_filepath ne '') {
    $replace_tag = $KEYWD_STDIN_DATA;
}

my @lines;
if ($source_filepath) {
    open(SIN, '<', $source_filepath) or die "Not found: $source_filepath";
    @lines = <SIN>;
    close SIN;
} else {
    @lines = <>;
}
@lines = map { decode('utf-8', $_) } @lines;

$ENV{$ENV_SELF_PATH} = $0;
$ENV{$ENV_TMP_PATH} = tempdir(CLEANUP => 1);
unless ($is_dryrun) {
    $save_file_dryrun = '';
}

my $ast;
if ($type_from eq 'json') {
    $ast = parse_json(@lines);
} elsif ($type_from eq 'sexpr') {
    $ast = parse_sexpr(@lines);
} else {
    die;
}

my ($exec_source, $bin_path, $ext);

if ($type_to eq 'obj') {
    my $source = gent_obj($ast, $to_lang, $to_ver);

    if ($template_source_filepath eq '') {
        print encode('utf-8', $source);
        print "\n";
        exit(0);
    } else {
        my @template_lines;
        open(SIN, '<', $template_source_filepath) or die "Not found: $template_source_filepath";
        @template_lines = <SIN>;
        close SIN;
        my $template = join('', @template_lines);
        $exec_source = build_by_template($template, $replace_tag, $source);

        ($bin_path, $ext) = lang_to_bin_path($to_lang);
    }
} else {
    my ($lang, $source);
    ($lang, $bin_path, $source, $ext) = gent_exec($ast);
    $source = $source . get_comments_about_saved_files($lang);

    $exec_source = $source;
}

if ($is_dryrun) {
    print encode('utf-8', $exec_source);
    exit(0);
}

my $script_path = $ENV{$ENV_TMP_PATH} . '/' . save_file($exec_source, $ext, '');
my $pid = fork;
if ($pid) {
    wait;
} elsif (defined $pid) {
    exec($bin_path, $script_path);
} else {
    die;
}


