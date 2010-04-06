package Local::Moose::Website::Build;
use parent 'Module::Build';
use File::Path qw(make_path);

sub ACTION_code {
    my ($self) = @_;
    my $out = $self->destdir;
    make_path($out);
    system $^X, 'bin/build_site.pl', '--outdir', $out;
    $self->add_to_cleanup($out);
    $self->depends_on('config_data');
    return;
}

1;
