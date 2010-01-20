package Text::UTX::Implementation::Dumper::UTX::Simple::Latest::Body;


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
# general dependency(-ies)
# ****************************************************************

use List::MoreUtils qw(apply);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# public method(s)
# ****************************************************************

sub dump_body {
    my $self = shift;

    my @body_lines;

    my $max_column_index = $self->count_columns - 1;

    # Todo: implement it!
    foreach my $entry ($self->all_entries) {
        my @columns = @{ $entry->{items} };
        if ($self->are_blank_columns_drew) {
            $#columns = $max_column_index;
            @columns = apply {
                $_ = $self->format->blank_entry
                    unless defined $_;
            } @columns;
        }
        push @body_lines, (
            join $self->format->entry_delimiter, @columns
        );
    }

    return \@body_lines;
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

Text::UTX::Implementation::Dumper::UTX::Simple::Latest::Body - 

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
