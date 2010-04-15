package Moose::Website::Resource::Templates;
use Moose;
use Resource::Pack;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Resource::Pack::Resource';

has '+name' => (default => 'templates');

sub BUILD {
    my $self = shift;

    resource $self => as {
        install_from(Path::Class::File->new(__FILE__)->parent
                                                     ->subdir('Templates'));
        dir template_dir => (
            dir        => '.',
            install_as => '',
        );
    };
}

__PACKAGE__->meta->make_immutable;

no Moose; no Resource::Pack; 1;

__END__

=pod

=head1 NAME

Moose::Website::Resource::Templates - A Moosey solution to this problem

=head1 SYNOPSIS

  use Moose::Website::Resource::Templates;

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
