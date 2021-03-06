
# コマンドの動作パターン(run_type):
#   from_stdin: 標準入力からオブジェクトを受け取って、コード生成 & 実行
#   from_file:  ファイルからオブジェクトを受け取って、コード生成 & 実行
#   from_stdin: 標準入力からオブジェクトを受け取って、オブジェクト生成
#   from_file:  標準入力からオブジェクトを受け取って、オブジェクト生成

my $ver = 0;
my $format_from = '';
my $source_filepath = '';
my $is_dryrun = '';
my $is_version = '';

while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg =~ /\A--from-([a-z0-9]+)\z/) {
        die if ($format_from ne '');
        $format_from = get_src_format_label($1);
        die "Unknown argument: $arg" unless (defined($format_from));
    } elsif ($arg eq '--dry-run') {
        $is_dryrun = 1;
    } elsif ($arg eq '--experimental') {
        $is_experimental = 1;
    } elsif ($arg eq '--version') {
        $is_version = 1;
    } elsif ($arg =~ /\A-/) {
        die "Unknown argument: $arg";
    } else {
        die if ($source_filepath);
        $source_filepath = $arg;
    }
}

if (defined($ENV{$ENV_EXPERIMENTAL}) && $ENV{$ENV_EXPERIMENTAL} ne '') {
    $is_experimental = 1;
}

if ($is_version) {
    print_version_info();
    exit 0;
}

my $run_type = '';

if ($source_filepath eq '') {
    $run_type = 'from_stdin';
} else {
    $run_type = 'from_file';
}

if ($format_from eq '') {
    $format_from = $FORMAT_SEXPR;
}

my $source_from;
my $source_format;
if ($run_type eq 'from_file') {
    $source_from = 'file';
    $source_format = $format_from;
} else {
    $source_from = 'stdin';
    $source_format = $format_from;
}

my @lines;
if ($source_from eq 'file') {
    open(SIN, '<', $source_filepath) or die "Not found: $source_filepath";
    @lines = <SIN>;
    close SIN;
} else {
    @lines = <>;
}
@lines = map { decode('utf-8', $_) } @lines;

$ENV{$ENV_SELF_PATH} = File::Spec->rel2abs($0);
$ENV{$ENV_TMP_PATH} = tempdir(CLEANUP => 1);

my $ast;
if ($source_format eq $FORMAT_SEXPR) {
    $ast = parse_sexpr(\@lines);
} elsif ($source_format eq $FORMAT_JSON) {
    $ast = parse_json(\@lines);
} else {
    die;
}

my ($exec_source, $ext) = sub {
    my ($bin_path, $ext, $lang, $source_head, $source_body);
    ($lang, $bin_path, $source_head, $source_body, $ext) = gent_exec($ast, $ver);
    my $source;
    ($lang, $bin_path, $ext, $source) = gen_print_saved_files($source_head, $source_body,
                                                              $lang, $bin_path, $ext);

    $source = '#!' . $bin_path . "\n\n" . $source;
    ($source, $ext);
}->();

if ($is_dryrun) {
    print encode('utf-8', $exec_source);
    exit(0);
}

my $script_path = $ENV{$ENV_TMP_PATH} . '/' . save_file($exec_source, $ext, '');
`chmod 700 $script_path`;
my $pid = fork;
if ($pid) {
    wait;
} elsif (defined $pid) {
    exec($script_path);
} else {
    die;
}

if ($?) {
    my $e = $? >> 8;
    if (!$e) {
        $e = 1;
    }
    exit $e;
}

