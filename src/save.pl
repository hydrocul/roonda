
my @saved_files = ();

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

    if ( -e $target_path) {
        `rm $filename`;
    } else {
        `mv $filename $target_path`;
    }

    push(@saved_files, $target_name);

    $target_name;
}

sub get_comments_about_saved_files {
    my ($lang) = @_;
    my $roonda_tmp_path = $ENV{$ENV_TMP_PATH};
    my $result = "";
    foreach my $file_name (@saved_files) {
        open(IN, '<', "$roonda_tmp_path/$file_name") or die "Cannot open";
        my @lines = <IN>;
        close IN;
        $result = $result . "\n";
        my $source = join('', @lines);
        my $source_comment;
        if ($lang eq $LANG_SH) {
            my $splitter = "#################################################";
            my $header = "$splitter\n# $file_name:\n$splitter\n";
            $source_comment = $header . escape_sh_multiline_comment($source);
        } elsif ($lang eq $LANG_PERL) {
            my $splitter = "#################################################";
            my $header = "$splitter\n# $file_name:\n$splitter\n";
            $source_comment = $header . escape_perl_multiline_comment($source);
        } else {
            die;
        }
        $result = $result . $source_comment;
    }
    $result;
}


