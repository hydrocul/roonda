
my @saved_files = ();
my %saved_files_content = ();

sub save_file {
    my ($content, $ext, $keep, $name) = @_;

    my ($fh, $filename) = tempfile;
    print $fh encode('utf-8', $content);
    close $fh;

    save_file_from_tempfile($filename, $name, $ext, $keep, $content);
}

sub save_file_from_tempfile {
    my ($filename, $name, $ext, $keep, $content) = @_;

    my $prefix = 'roonda_';

    unless ($name) {
        $name = $prefix . calc_sha1($content, $filename);
    }

    my $roonda_tmp_path = $ENV{$ENV_TMP_PATH};

    my $target_path;
    my $target_name;
    if ($ext) {
        $target_path = "$roonda_tmp_path/$name.$ext";
        $target_name = "$name.$ext";
    } else {
        $target_path = "$roonda_tmp_path/$name";
        $target_name = "$name";
    }

    unless (defined($content)) {
        die; # TODO
    }

    if ($keep) {
        if (!grep { $_ eq $target_name } @saved_files) {
            push(@saved_files, $target_name);
        }
        $saved_files_content{$target_name} = $content;
    }

    if ($is_dryrun) {
        `rm $filename`;
    } elsif ( -e $target_path) {
        `rm $filename`;
    } else {
        `mv $filename $target_path`;
    }

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
    foreach my $file_name (@saved_files) {
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


