
my $ver = '';
my $format_from = '';
my $run_type = '';
my $lang_to = '';
my $is_dryrun = '';
my $replace_tag = '';
my $source_filepath = '';
my $template_source_filepath = '';
while () {
    last if (!@ARGV);
    my $arg = shift;
    if ($arg =~ /\A--v(\d+)\Z/) {
        die if ($ver ne '');
        $ver = $1;
    } elsif ($arg =~ /\A--from-([a-z0-9]+)\Z/) {
        die if ($format_from ne '');
        $format_from = get_src_format_label($1);
        die "Unknown argument: $arg" unless (defined($format_from));
    } elsif ($arg =~ /\A--([a-z0-9]+)-to-([a-z0-9]+)\Z/) {
        die if ($format_from ne '');
        die if ($run_type ne '');
        $format_from = get_src_format_label($1);
        die "Unknown argument: $arg" unless (defined($format_from));
        $run_type = 'obj';
        $lang_to = get_dst_format_label($2);
        die "Unknown argument: $arg" unless (defined($lang_to));
    } elsif ($arg =~ /\A--to-([a-z0-9]+)-obj\Z/) {
        die if ($run_type ne '');
        $run_type = 'obj';
        $lang_to = get_dst_format_label($1);
        die "Unknown argument: $arg" unless (defined($lang_to));
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
        if ($run_type eq 'obj') {
            die if ($template_source_filepath);
            $template_source_filepath = $arg;
        } else {
            die if ($source_filepath);
            $source_filepath = $arg;
        }
    }
}

if ($ver eq '') {
    $ver = 1;
}
if ($format_from eq '') {
    $format_from = $FORMAT_SEXPR;
}
if ($run_type eq '') {
    $run_type = 'exec';
}

if ($run_type eq 'obj' && $replace_tag ne '' && $template_source_filepath eq '') {
    die;
}
if ($run_type ne 'obj' && $replace_tag ne '') {
    die;
}

if ($run_type eq 'obj' && $replace_tag eq '' && $template_source_filepath ne '') {
    $replace_tag = $KEYWD_STDIN_DATA;
}

$save_file_dryrun = '' unless ($is_dryrun);

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

my $ast;
if ($format_from eq $FORMAT_SEXPR) {
    $ast = parse_sexpr(@lines);
} elsif ($format_from eq $FORMAT_JSON) {
    $ast = parse_json(@lines);
} else {
    die;
}

my ($exec_source, $bin_path, $ext);

if ($run_type eq 'obj') {
    my $source = gent_obj($ast, $lang_to, $ver);

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

        ($bin_path, $ext) = lang_to_bin_path($lang_to);
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


