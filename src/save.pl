
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
    die unless ($key =~ /\A(..)([^ ]+) /);
    my $key1 = $1;
    my $key2 = $2;

    my $storage_dir = $ENV{'HOME'} . '/.roonda/storage';

    if ( -e "$storage_dir/$key1/$key2/content") {
        `rm $filename`;
    } else {
        `mkdir -p $storage_dir/$key1/$key2 && mv $filename $storage_dir/$key1/$key2/content`;
    }
    if ($ext && ! -e "$storage_dir/$key1/$key2/content.$ext") {
        `ln -s content $storage_dir/$key1/$key2/content.$ext`;
    }

    if ($ext) {
        "$storage_dir/$key1/$key2/content.$ext";
    } else {
        "$storage_dir/$key1/$key2/content";
    }
}

