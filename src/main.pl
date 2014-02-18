
# コマンドの動作パターン(run_type):
#   from_stdin: 標準入力からオブジェクトを受け取って、コード生成 & 実行
#   from_file:  ファイルからオブジェクトを受け取って、コード生成 & 実行
#   from_stdin: 標準入力からオブジェクトを受け取って、オブジェクト生成
#   from_file:  標準入力からオブジェクトを受け取って、オブジェクト生成

my $ver = '';
my $format_from = '';
my $is_dryrun = '';
my $source_filepath = '';
my $format_to = ''; # オブジェクト生成の場合のみ

while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg =~ /\A--v(\d+)\z/) {
        die if ($ver ne '');
        $ver = $1;
    } elsif ($arg =~ /\A--from-([a-z0-9]+)\z/) {
        die if ($format_from ne '');
        $format_from = get_src_format_label($1);
        die "Unknown argument: $arg" unless (defined($format_from));
    } elsif ($arg =~ /\A--([a-z0-9]+)-to-([a-z0-9]+)-obj\z/) {
        die if ($format_from ne '');
        $format_from = get_src_format_label($1);
        die "Unknown argument: $arg" unless (defined($format_from));
        die if ($format_to ne '');
        $format_to = get_dst_format_label($2);
        die "Unknown argument: $arg" unless (defined($format_to));
    } elsif ($arg =~ /\A--to-([a-z0-9]+)-obj\z/) {
        die if ($format_to ne '');
        $format_to = get_dst_format_label($1);
        die "Unknown argument: $arg" unless (defined($format_to));
    } elsif ($arg eq '--output-code') {
        $is_dryrun = 1;
    } elsif ($arg =~ /\A-/) {
        die "Unknown argument: $arg";
    } else {
        die if ($source_filepath);
        $source_filepath = $arg;
    }
}

my $run_type = '';

if ($ver eq '') {
    $ver = 1;
} else {
    my $ver2 = $ver + 0;
    if ($ver2 ne $ver) {
        die "Unknown argument: --v$ver";
    }
    $ver = $ver2;
}

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

$save_file_dryrun = $is_dryrun;

my @lines;
if ($source_from eq 'file') {
    open(SIN, '<', $source_filepath) or die "Not found: $source_filepath";
    @lines = <SIN>;
    close SIN;
} else {
    @lines = <>;
}
@lines = map { decode('utf-8', $_) } @lines;

$ENV{$ENV_SELF_PATH} = $0;
$ENV{$ENV_TMP_PATH} = tempdir(CLEANUP => 1);

my $ast;
if ($source_format eq $FORMAT_SEXPR) {
    $ast = parse_sexpr(\@lines, $ver);
} elsif ($source_format eq $FORMAT_JSON) {
    $ast = parse_json(\@lines, $ver);
} else {
    die;
}

if ($format_to) {
    my $source = gent_obj($ast, $format_to, $ver);

    print encode('utf-8', $source);
    print "\n";
    exit(0);
}

my ($exec_source, $bin_path, $ext) = sub {
    my ($bin_path, $ext, $lang, $source);
    ($lang, $bin_path, $source, $ext) = gent_exec($ast, $ver);
    $source = $source . get_comments_about_saved_files($lang);

    ($source, $bin_path, $ext);
}->();

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

if ($?) {
    my $e = $? >> 8;
    if (!$e) {
        $e = 1;
    }
    exit $e;
}

