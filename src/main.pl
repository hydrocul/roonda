
my $type_from = 'sexpr';
my $output_code = '';
my $source_filepath = '';
while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg eq '--from-json') {
        $type_from = 'json';
    } elsif ($arg eq '--from-sexpr') {
        $type_from = 'sexpr';
    } elsif ($arg eq '--from-plobj') {
        $type_from = 'plobj';
    } elsif ($arg eq '--output-code') {
        $output_code = 1;
    } else {
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
my ($lang, $bin_path, $source, $ext) = eat_token_exec($ast);

$source = $source . get_comments_about_saved_files($lang);

if ($output_code) {
    print encode('utf-8', $source);
} else {
    my $script_path = $ENV{$ENV_TMP_PATH} . '/' . save_file($source, $ext);
    my $pid = fork;
    if ($pid) {
        wait;
    } elsif (defined $pid) {
        exec($bin_path, $script_path);
    } else {
        die;
    }
}

