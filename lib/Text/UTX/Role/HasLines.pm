package Text::UTX::Role::HasLines;


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

has 'lines' => (
    traits      => [qw(
        Array
    )],
    is          => 'ro',
    # writer      => '_set_lines',
    isa         => 'ArrayRef[Str]',
    # init_arg    => undef,
    # required    => 1,
    lazy_build  => 1,
    handles     => {
        all_lines    => 'elements',
        add_line     => 'push',
        add_lines    => 'push',
        count_lines  => 'count',
        filter_lines => 'grep',
        get_line     => 'get',
        join_lines   => 'join',
        map_lines    => 'map',
        splice_lines => 'splice',
        as_string    => [ join => ("\n") ],
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

Text::UTX::Role::HasLines - 

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
