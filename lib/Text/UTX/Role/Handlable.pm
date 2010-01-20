package Text::UTX::Role::Handlable;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose::Role;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'aliases' => (
    traits      => [qw(
        Array
    )],
    is          => 'rw',
    isa         => 'ArrayRef[Str]',
    lazy_build  => 1,
    handles     => {
        find_alias => 'first',
    },
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Interface::Handler
);


# ****************************************************************
# public method(s)
# ****************************************************************

# Note: ensure class name canonized
sub canonize {
    my ($self, $role_kind, $framework, $alias) = @_;

    my $fully_qualified_class_name
        = $self->fully_qualified_class_name($role_kind);

    return
        if $alias ne $fully_qualified_class_name
        && $alias ne $self->partly_qualified_class_name
        && ! $self->find_alias( sub { lc $_ eq lc $alias } );

    return $fully_qualified_class_name;
}


# ****************************************************************
# return true
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Text::UTX::Role::Handlable - 

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at cpan dot org> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com/>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
