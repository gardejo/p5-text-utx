package Text::UTX::Implementation::Parser::UTX::Simple::Latest::Body;


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
# public method(s)
# ****************************************************************

sub parse_body {
    my $self = shift;

    # Note: treat a copy array instead of an array reference
    #       to avoid side-effects on 'lines' attribute
    my @all_lines  = $self->all_lines;
    my @body_lines = splice @all_lines, $self->count_header_lines;

    my @entries;

    foreach my $body_line (@body_lines) {
        my $is_comment = ( $body_line =~ s{ \A \#+ \s* }{}xmsg );
        my @items = split $self->format->entry_delimiter_pattern, $body_line;
        push @entries, {
            is_comment => $is_comment,
            items      => \@items,
        };
    }

    return \@entries;
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

Text::UTX::Implementation::Parser::UTX::Simple::Latest::Body - 

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
