package Moose::Website::Resource::WebFiles;
use Moose;
use Resource::Pack;

use Moose::Website::Resource::jQuery;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Resource::Pack::Resource';

has '+name' => (default => 'webfiles');

sub BUILD {
    my $self = shift;

    resource $self => as {
        install_from(Path::Class::File->new(__FILE__)->parent
                                                     ->subdir('WebFiles'));

        resource(Moose::Website::Resource::jQuery->new);

        dir 'css';
        dir 'images';
        dir js => (
            dir          => 'js',
            dependencies => ['jquery/core'],
        );
    };
}

__PACKAGE__->meta->make_immutable;

no Moose; no Resource::Pack; 1;

__END__

=pod

=head1 NAME

Moose::Website::Resource::WebFiles - A Moosey solution to this problem

=head1 SYNOPSIS

  use Moose::Website::Resource::WebFiles;

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
