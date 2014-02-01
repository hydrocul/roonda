
my $type_from = '';
my $from_ver = '';
my $type_to = '';
my $to_lang = '';
my $to_ver = '';
my $source_filepath = '';
while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg =~ /--from-json-(\d+)/) {
        die if ($type_from ne '');
        $type_from = 'json';
        $from_ver = $1;
    } elsif ($arg eq '--from-sexpr') {
        die if ($type_from ne '');
        $type_from = 'sexpr';
    } elsif ($arg =~ /--([a-z0-9]+)-(\d+)-to-([a-z0-9]+)-(\d+)/) {
        die if ($type_from ne '');
        die if ($type_to ne '');
        if ($1 eq 'sexpr') {
            $type_from = 'sexpr';
        } elsif ($1 eq 'json') {
            $type_from = 'json';
        } else {
            die "Unknown argument: $arg";
        }
        $from_ver = $2;
        $type_to = 'obj';
        if ($3 eq 'perl') {
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
    } elsif ($arg eq '--output-code') {
        die if ($type_to ne '');
        $type_to = 'code';
    } elsif ($arg =~ /\A-/) {
        die "Unknown argument: $arg";
    } else {
        die if ($source_filepath);
        $source_filepath = $arg;
    }
}

if ($type_from eq '') {
    $type_from = 'sexpr';
}
if ($type_to eq '') {
    $type_to = 'exec';
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
if ($type_to eq 'exec') {
    $save_file_dryrun = '';
}

my $ast;
if ($type_from eq 'json') {
    $ast = parse_json(@lines);
} else {
    $ast = parse_sexpr(@lines);
}

if ($type_to eq 'obj') {
    my $source = gent_obj($ast, $to_lang, $to_ver);
    print encode('utf-8', $source);
    print "\n";
    exit(0);
}

if ($type_to ne 'code' && $type_to ne 'exec') {
    die;
}

my ($lang, $bin_path, $source, $ext) = gent_exec($ast);
$source = $source . get_comments_about_saved_files($lang);

if ($type_to eq 'code') {
    print encode('utf-8', $source);
    exit(0);
}

die unless ($type_to eq 'exec');

my $script_path = $ENV{$ENV_TMP_PATH} . '/' . save_file($source, $ext, '');
my $pid = fork;
if ($pid) {
    wait;
} elsif (defined $pid) {
    exec($bin_path, $script_path);
} else {
    die;
}


