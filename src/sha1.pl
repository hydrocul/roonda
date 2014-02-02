
sub calc_sha1 {
    my ($content, $filename) = @_;

    my $tmp_filename;
    unless (defined($filename)) {
        my $fh;
        ($fh, $tmp_filename) = tempfile;
        print $fh encode('utf-8', $content);
        close $fh;
        $filename = $tmp_filename;
    }

    my $key = `sha1sum $filename`; # TODO ファイルに保存しなくてもsha1をとれるようにすべき

    if (defined($tmp_filename)) {
        `rm $tmp_filename`;
    }

    die unless ($key =~ /\A([^\s]+)/);
    return $1;
}
