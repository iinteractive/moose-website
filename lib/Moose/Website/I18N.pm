package Moose::Website::I18N;
use Moose;

use Path::Class;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

BEGIN { extends 'Locale::Maketext' };

use Locale::Maketext::Lexicon {
    '*'     => [ Gettext => file(__FILE__)->parent->file("I18N", "po", "*.po")->stringify ],
    _auto   => 1,
    _decode => 1,
};

sub loc {
    my ( $self, $item, @args ) = @_;

    if ( @args == 0 and ref($item) eq 'ARRAY') {
        ( $item, @args ) = @$item;
    }

    return $self->maketext( $item, @args );
}

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

no Moose; 1;

__END__

=pod

=head1 NAME

Moose::Website::I18N - A Moosey solution to this problem

=head1 SYNOPSIS

  use Moose::Website::I18N;

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
