
sub escape_sh_string {
    my ($str) = @_;
    return $str if ($str =~ /\A[-.\/_0-9A-Za-z]+\Z/);
    $str =~ s/'/'\\''/g;
    "'" . $str . "'";
    "'" . $str . "'";
}

sub escape_sh_backticks {
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\$/\\\$/g;
    $str =~ s/`/\\`/g;
    $str =~ s/"/\\"/g;
    "`" . $str . "`";
}

sub escape_sh_multiline_comment {
    my ($str) = @_;
    $str =~ s/\n/\n# /g;
    $str =~ s/# \Z//g;
    $str =~ s/[^\n]\Z/\n/g;
    $str = '# ' . $str;
    $str;
}

sub escape_perl_string {
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\a/\\a/g;
    $str =~ s/\e/\\e/g;
    $str =~ s/\f/\\f/g;
    $str =~ s/\n/\\n/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\t/\\t/g;
    $str =~ s/([\x00-\x1F])/sprintf("\\x%02x",ord($1))/ge;
    $str =~ s/\$/\\\$/g;
    $str =~ s/\@/\\\@/g;
    $str =~ s/"/\\"/g;
    "\"" . $str . "\"";
}

sub escape_perl_multiline_comment {
    my ($str) = @_;
    $str =~ s/\n/\n# /g;
    $str =~ s/# \Z//g;
    $str =~ s/[^\n]\Z/\n/g;
    $str = '# ' . $str;
    $str;
}

