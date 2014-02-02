
sub escape_sexpr_string {
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\n/\\n/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\t/\\t/g;
    $str =~ s/"/\\"/g;
    "\"" . $str . "\"";
}

sub unescape_sexpr_string {
    my ($str) = @_;
    $str =~ s/\\n/\n/g;
    $str =~ s/\\r/\r/g;
    $str =~ s/\\t/\t/g;
    $str =~ s/\\"/"/g;
    $str =~ s/\\\\/\\/g;
    $str =~ s/\\u([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])/chr(hex($1))/ge;
    $str;
}

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
    $str = $str . "\n";
    $str =~ s/\n\n\Z/\n/g;
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
    $str = $str . "\n";
    $str =~ s/\n\n\Z/\n/g;
    $str = '# ' . $str;
    $str;
}

sub escape_ruby_string {
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\a/\\a/g;
    $str =~ s/\x07/\\b/g;
    $str =~ s/\e/\\e/g;
    $str =~ s/\f/\\f/g;
    $str =~ s/\n/\\n/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\t/\\t/g;
    $str =~ s/([\x00-\x1F])/sprintf("\\x%02x",ord($1))/ge;
    $str =~ s/#/\\#/g;
    $str =~ s/"/\\"/g;
    "\"" . $str . "\"";
}

sub escape_python2_string {
    my ($str) = @_;
    escape_python_string($str, 2);
}

sub escape_python3_string {
    my ($str) = @_;
    escape_python_string($str, 3);
}

sub escape_python_string { # TODO
    my ($str, $v) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\n/\\n/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\t/\\t/g;
    $str =~ s/([\x00-\x1F])/sprintf("\\x%02x",ord($1))/ge;
    $str =~ s/"/\\"/g;
    "\"" . $str . "\"";
}

sub escape_php_string { # TODO
    my ($str) = @_;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\n/\\n/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\t/\\t/g;
    $str =~ s/([\x00-\x1F])/sprintf("\\x%02x",ord($1))/ge;
    $str =~ s/"/\\"/g;
    "\"" . $str . "\"";
}

