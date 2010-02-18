package Text::UTX::Type::IxHash;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer cannot detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use MooseX::Types -declare => [qw(
    IxHash
)];
use MooseX::Types::Moose qw(
    ArrayRef
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Tie::IxHash;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# indexed hash
# ----------------------------------------------------------------
subtype IxHash,
    as class_type('Tie::IxHash');

coerce IxHash,
    from ArrayRef,
        via {
            return Tie::IxHash->new(@$_);
        };


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

Text::UTX::Type::IxHash - Tie::IxHash related constraints and coercions for Moose

=head1 SYNOPSIS

    {
        package Foo;

        use Moose;
        use Text::UTX::Type::IxHash qw(
            IxHash
        );

        has 'ixhash'
            => ( isa => IxHash, is => 'rw', coerce => 1 );

        __PACKAGE__->meta->make_immutable;
    }

    my $foo = Foo->new(ixhash => [foo => 0, bar => 1]);

=head1 DESCRIPTION

This module packages several
L<Moose::Util::TypeConstraints|Moose::Util::TypeConstraints> with coercions,
designed to work with the values of L<Tie::IxHash|Tie::IxHash>.

=head1 CONSTRAINTS AND COERCIONS

=over 4

=item C<IxHash>

A subtype of C<HashRef>,
which should be a L<Tie::IxHash|Tie::IxHash> object.

=back

=head1 SEE ALSO

=over 4

=item * L<Tie::IxHash|Tie::IxHash>

=back

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
