
sub save_file {
    my ($content, $ext) = @_;

    my ($fh, $filename) = tempfile;
    print $fh encode('utf-8', $content);
    close $fh;

    save_file_from_tempfile($filename, $ext);
}

sub save_file_from_tempfile {
    my ($filename, $ext) = @_;

    my $key=`sha1sum $filename`;
    die unless ($key =~ /\A([^\s]+)/);
    $key = $1;

    my $roonda_tmp_path = $ENV{$ENV_TMP_PATH};

    my $target_path;
    my $target_name;
    if ($ext) {
        $target_path = "$roonda_tmp_path/$key.$ext";
        $target_name = "$key.$ext";
    } else {
        $target_path = "$roonda_tmp_path/$key";
        $target_name = "$key";
    }

    if ( -e $target_path) {
        `rm $filename`;
    } else {
        `mv $filename $target_path`;
    }

    $target_name;
}

