use lib 'inc';
use Local::Moose::Website::Build;
my $self = Local::Moose::Website::Build->new(
    module_name        => 'Moose::Website',
    configure_requires => {
        'File::Path'    => 0,
        'Module::Build' => 0,
    },
    build_requires => {
        'Capture::Tiny' => 0,
        Encode          => 0,
        'File::Next'    => 0,
        'File::Temp'    => 0,
        'File::Which'   => 0,
        'Test::More'    => 0,
        'XML::LibXML'   => 0,
        'XML::LibXSLT'  => 0,
    },
    requires => {
        'Locale::Maketext::Lexicon'  => 0,
        Moose                        => 0,
        'MooseX::Params::Validate'   => 0, 
        'MooseX::Role::Parameterized'=> 0, 
        'MooseX::Types::Path::Class' => 0,
        'Path::Class'                => 0,
        'Resource::Pack'             => 0,   # http://github.com/stevan/Resource-Pack
        Template                     => 0,
        'YAML::XS'                   => 0,
    },
);
die "perldoc Build.PL\n" unless $self->destdir;

$self->create_build_script;

__END__

=encoding UTF-8

=head1 SYNOPSIS

    perl Build.PL --destdir=out
    ./Build test
    ./Build distclean
