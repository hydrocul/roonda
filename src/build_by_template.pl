
sub build_by_template {
    my ($template, $replace_obj_tag, $replace_obj) = @_;
    my $source = $template;
    $source =~ s{$replace_obj_tag}{$replace_obj}g;
    $source;
}

