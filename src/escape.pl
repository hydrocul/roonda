
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
    $str =~ s/(\\+)n/_unescape_sexpr_string_replace($1,'n',"\n")/ge;
    $str =~ s/(\\+)r/_unescape_sexpr_string_replace($1,'r',"\r")/ge;
    $str =~ s/(\\+)t/_unescape_sexpr_string_replace($1,'t',"\t")/ge;
    $str =~ s/(\\+)"/_unescape_sexpr_string_replace($1,'"',"\"")/ge;
    $str =~ s/(\\+)u([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])/
              _unescape_sexpr_string_replace($1,"u$2",chr(hex($1)))/ge;
    $str =~ s/\\\\/\\/g;
    $str;
}

sub _unescape_sexpr_string_replace {
    my ($s1, $s2, $s3) = @_;
    if (length($s1) % 2 == 0) {
        "$s1$s2";
    } else {
        ('\\' x (length($s1) - 1)) . $s3;
    }
}
sub _unescape_sexpr_string_replace_unicode {
    my ($s1, $s2, $s3, $s4) = @_;
    if (length($s1) % 2 == 0) {
        "$s1$s2";
    } else {
        ('\\' x (length($s1) - 1)) . $s3;
    }
}

sub escape_sh_string {
    my ($str) = @_;
    return $str if ($str =~ /\A[-.\/_0-9A-Za-z]+\z/);
    $str =~ s/\\/\\\\/g;
    $str =~ s/'/'\\''/g;
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
    $str =~ s/# \z//g;
    $str = $str . "\n";
    $str =~ s/\n\n\z/\n/g;
    $str = '# ' . $str;
    $str;
}

sub exists_perl_wide_char {
    my ($str) = @_;
    if ($str =~ /\A[\x00-\x7F]*\z/) {
        '';
    } else {
        1;
    }
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
    $str =~ s/# \z//g;
    $str = $str . "\n";
    $str =~ s/\n\n\z/\n/g;
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

