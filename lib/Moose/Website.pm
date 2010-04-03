package Moose::Website;
use Moose;
use MooseX::Types::Path::Class;

use Path::Class;
use Template;
use YAML::XS 'LoadFile';

use Moose::Website::I18N;
use Moose::Website::Resource::Templates;
use Moose::Website::Resource::WebFiles;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'MooseX::Getopt';

has 'outdir' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    coerce   => 1,
    required => 1,
);

has 'locale' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { 'en' },
);

has 'page_file' => (
    is       => 'ro',
    isa      => 'Path::Class::File',
    coerce   => 1,
    default  => sub {
        file(__FILE__)->parent->parent->parent->file('data', 'pages.yml')
    }
);

# ....

has 'template_resource' => (
    traits  => [ 'NoGetopt' ],
    is      => 'ro',
    isa     => 'Moose::Website::Resource::Templates',
    lazy    => 1,
    default => sub {
        Moose::Website::Resource::Templates->new
    },
    handles  => {
        'template_root' => 'dir'
    }
);

has 'web_file_resource' => (
    traits  => [ 'NoGetopt' ],
    is      => 'ro',
    isa     => 'Moose::Website::Resource::WebFiles',
    lazy    => 1,
    default => sub {
        Moose::Website::Resource::WebFiles->new
    },
);

has 'i18n' => (
    traits  => [ 'NoGetopt' ],
    is      => 'ro',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my $self = shift;
        Moose::Website::I18N->get_handle( $self->locale )
    }
);

has 'pages' => (
    traits  => [ 'NoGetopt' ],
    is      => 'ro',
    isa     => 'ArrayRef[HashRef]',
    lazy    => 1,
    default => sub {
        my $self = shift;
        LoadFile( $self->page_file->stringify );
    }
);

has 'tt' => (
    traits  => [ 'NoGetopt' ],
    is      => 'ro',
    isa     => 'Template',
    lazy    => 1,
    default => sub {
        my $self = shift;
        Template->new(
            INCLUDE_PATH => $self->template_root,
            %{ $self->template_config }
        )
    }
);

has 'template_config' => (
    traits  => [ 'NoGetopt' ],
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

sub log { shift; warn @_, "\n" }

sub run {
    my $self = shift;

    foreach my $page ( @{ $self->pages } ) {

        my $outfile = $self->outdir->file( $page->{outfile} )->stringify;

        $self->log( "Writing page " . $page->{name} . " to $outfile using template " . $page->{template} );

        $self->tt->process(
            $page->{template},
            $self->build_template_params( current_page => $page ),
            $outfile
        ) || confess $self->tt->error;
    }

    $self->log( "Copying web resources to " . $self->outdir );
    $self->web_file_resource->copy( to => $self->outdir );
}

sub build_template_params {
    my ($self, %params) = @_;

    $params{ pages }  = $self->pages;
    $params{ loc }    = sub { $self->i18n->loc( @_ ) };
    $params{ locale } = $self->locale;

    \%params;
}


__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Moose::Website - A Moosey solution to this problem

=head1 SYNOPSIS

  use Moose::Website;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
