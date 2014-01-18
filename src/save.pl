
sub save_file {
    my ($content, $ext, $roonda_tmp_path) = @_;

    my ($fh, $filename) = tempfile;
    print $fh encode('utf-8', $content);
    close $fh;

    save_file_from_tempfile($filename, $ext, $roonda_tmp_path);
}

sub save_file_from_tempfile {
    my ($filename, $ext, $roonda_tmp_path) = @_;

    my $key=`sha1sum $filename`;
    die unless ($key =~ /\A([^\s]+)/);
    $key = $1;

    my $target_path;
    if ($ext) {
        $target_path = "$roonda_tmp_path/$key.$ext";
    } else {
        $target_path = "$roonda_tmp_path/$key";
    }

    if ( -e $target_path) {
        `rm $filename`;
    } else {
        `mv $filename $target_path`;
    }

    $target_path;
}

