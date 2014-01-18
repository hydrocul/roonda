
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

my $tokens = parse_source(@lines);
my $sexpr = build_sexpr($tokens);
my ($bin_path, $source) = eat_token_exec($sexpr);

if ($output_code) {
    print encode('utf-8', $source);
} else {
    $ENV{$ENV_TMP_PATH} = tempdir(CLEANUP => 1);
    my $script_path = save_file($source, 'sh', $ENV{$ENV_TMP_PATH});
    my $pid = fork;
    if ($pid) {
        wait;
    } elsif (defined $pid) {
        exec($bin_path, $script_path);
    } else {
        die;
    }
}

