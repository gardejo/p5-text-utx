package Text::UTX::Role::HasColumns;


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

use Moose::Role;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Type::IxHash qw(IxHash);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'columns' => (
    is          => 'ro',
    isa         => IxHash,
    coerce      => 1,
    init_arg    => undef,
    handles     => {
        all_universal_columns => 'Keys',
        clear_columns         => [ 'Splice' => (0)  ],
        get_universal_column  => [ 'Keys'   => (@_) ],
        get_universal_columns => [ 'Keys'   => (@_) ],
        get_native_column     => [ 'Values' => (@_) ],
        get_native_columns    => [ 'Values' => (@_) ],
        set_column            => [ 'Push'   => (@_) ],
        set_columns           => [ 'Push'   => (@_) ],
    },
    default     => sub {
        [];
    },
);


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

Text::UTX::Role::HasColumns - 

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
