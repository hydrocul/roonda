
my $type_from = 'sexpr';
my $type_to = '';
my $to_lang = '';
my $to_ver = '';
my $source_filepath = '';
while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg eq '--from-json') {
        $type_from = 'json';
    } elsif ($arg eq '--from-sexpr') {
        $type_from = 'sexpr';
    } elsif ($arg eq '--to-perl-obj-1') {
        $type_to = 'obj';
        $to_lang = $LANG_PERL;
        $to_ver = 1;
    } elsif ($arg eq '--output-code') {
        $type_to = 'code';
    } else {
        die if ($source_filepath);
        $source_filepath = $arg;
    }
}

my @lines;
if ($source_filepath) {
    open(SIN, '<', $source_filepath) or die;
    @lines = <SIN>;
    close SIN;
} else {
    @lines = <>;
}
@lines = map { decode('utf-8', $_) } @lines;

$ENV{$ENV_TMP_PATH} = tempdir(CLEANUP => 1);

my $ast;
if ($type_from eq 'json') {
    $ast = parse_json(@lines);
} else {
    $ast = parse_sexpr(@lines);
}

if ($type_to eq 'obj') {
    my $source = gent_obj($ast, $to_lang, $to_ver);
    print encode('utf-8', $source);
    exit(0);
}

if ($type_to ne 'code' && $type_to ne '') {
    die;
}

my ($lang, $bin_path, $source, $ext) = gent_exec($ast);
$source = $source . get_comments_about_saved_files($lang);

if ($type_to eq 'code') {
    print encode('utf-8', $source);
    exit(0);
}

my $script_path = $ENV{$ENV_TMP_PATH} . '/' . save_file($source, $ext);
my $pid = fork;
if ($pid) {
    wait;
} elsif (defined $pid) {
    exec($bin_path, $script_path);
} else {
    die;
}


