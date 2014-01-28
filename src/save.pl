
my @saved_files = ();
my %saved_files_content = ();
my $save_file_dryrun = 1;

sub save_file {
    my ($content, $ext, $keep) = @_;

    my ($fh, $filename) = tempfile;
    print $fh encode('utf-8', $content);
    close $fh;

    save_file_from_tempfile($filename, $ext, $keep, $content);
}

sub save_file_from_tempfile {
    my ($filename, $ext, $keep, $content) = @_;

    my $key=`sha1sum $filename`; # TODO ファイルに保存しなくてもsha1をとれるようにすべき
    die unless ($key =~ /\A([^\s]+)/);
    $key = $1;

    my $roonda_tmp_path = $ENV{$ENV_TMP_PATH};
    my $prefix = 'roonda_';

    my $target_path;
    my $target_name;
    if ($ext) {
        $target_path = "$roonda_tmp_path/$prefix$key.$ext";
        $target_name = "$prefix$key.$ext";
    } else {
        $target_path = "$roonda_tmp_path/$prefix$key";
        $target_name = "$prefix$key";
    }

    unless (defined($content)) {
        die; # TODO
    }

    if ($keep) {
        $saved_files_content{$target_name} = $content;
    }

    if ($save_file_dryrun) {
        `rm $filename`;
    } elsif ( -e $target_path) {
        `rm $filename`;
    } else {
        `mv $filename $target_path`;
    }

    push(@saved_files, $target_name);

    $target_name;
}

sub get_saved_file {
    my ($name) = @_;
    $saved_files_content{$name};
}

sub get_comments_about_saved_files {
    my ($lang) = @_;
    my $roonda_tmp_path = $ENV{$ENV_TMP_PATH};
    my $result = "";
    foreach my $file_name (keys %saved_files_content) {
        my $content = $saved_files_content{$file_name};
        $result = $result . "\n";
        my $source_comment;
        if ($lang eq $LANG_SH) {
            my $splitter = "#################################################";
            my $header = "$splitter\n# $file_name:\n$splitter\n";
            $source_comment = $header . escape_sh_multiline_comment($content);
        } elsif ($lang eq $LANG_PERL) {
            my $splitter = "#################################################";
            my $header = "$splitter\n# $file_name:\n$splitter\n";
            $source_comment = $header . escape_perl_multiline_comment($content);
        } else {
            die;
        }
        $result = $result . $source_comment;
    }
    $result;
}


