
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

# return: ($lang, $bin_path, $ext, $source)
sub gen_print_saved_files {
    my ($source_head, $source_body, $lang, $bin_path, $ext) = @_;
    if (!@saved_files) {
        return ($lang, $bin_path, $ext, $source_head . $source_body);
    }
    if ($lang eq $LANG_SH) {
        return ($lang, $bin_path, $ext, gen_print_saved_files_by_sh($source_head, $source_body));
    }
    my $main_filename = save_file($source_head . $source_body, $ext, 1, undef);
    my $sh_source = escape_sh_string($bin_path) . ' ' .
        '$' . $ENV_TMP_PATH . '/' . escape_sh_string($main_filename) . "\n";
    my $_bin_path_for_sh;
    ($bin_path, $_bin_path_for_sh, $ext) = lang_to_bin_path($LANG_SH);
    ($LANG_SH, $bin_path, $ext, gen_print_saved_files_by_sh(get_source_header($LANG_SH, 1),
                                                            $sh_source));
}

#return: $source
sub gen_print_saved_files_by_sh {
    my ($source_head, $source_body) = @_;
    my ($_bin_path, $_bin_path_for_sh, $ext) = lang_to_bin_path($LANG_SH);
    my $result = "";
    my $splitter = "#################################################";
    foreach my $file_name (@saved_files) {
        my $content = $saved_files_content{$file_name};
        if ($content !~ /\n\z/) {
            $content = $content . "\n";
        }
        my $file_source = "# $file_name:\n$splitter\ncat " .
            "<<\\END_OF_ROONDA_SOURCE_FILE > \$$ENV_TMP_PATH/$file_name\n" .
            "${content}END_OF_ROONDA_SOURCE_FILE\n$splitter\n";
        $result = $result . $file_source;
    }
    $source_head . $splitter . "\n" . $result . "\n" . $source_body;
}


