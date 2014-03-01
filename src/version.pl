my $MAJOR_VERSION = 1;
my $MINOR_VERSION = 0;

# サポートする文法の最大バージョン
# 最大バージョンでは環境変数 ROONDA_EXPERIMENTAL を設定しないと動かない
my $MAX_VERSION = $MAJOR_VERSION + 1;

sub get_version_string {
    "0.$MAJOR_VERSION.$MINOR_VERSION";
}

sub print_version_info {
    my $version = get_version_string();
    print "roonda $version\n";
}
