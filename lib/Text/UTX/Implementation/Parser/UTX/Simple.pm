package Text::UTX::Implementation::Parser::UTX::Simple;


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
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Interface::Parser
    Text::UTX::Role::HasColumns
    Text::UTX::Role::HasLines
    Text::UTX::Role::HasFormat
    Text::UTX::Implementation::Format::UTX::Simple
);


# ****************************************************************
# inherited attribute(s)
# ****************************************************************

# has '+version' => (
#     trigger     => sub {
#         confess 'Could not modify version attribute '
#               . 'on feature concrete classes';
#     },
# );

# has '+lines' => (
#     trigger     => sub {
#         $_[0]->clear_columns;
#     },
# );


# ****************************************************************
# hook(s) on construction
# ****************************************************************

sub BUILD {
    my $self = shift;

    my $format_class = $self->fully_qualified_class_name('Format');
    if ($self->has_version) {
        $format_class .= '::'
                      .  $self->version_for_class_name( $self->version );
    }

    $self->format_class($format_class);

    return;
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub parse {
    my $self = shift;

    my $meta_information = $self->parse_header;

    return {
        %$meta_information,
        columns => [ $self->all_universal_columns ],
        entries => $self->parse_body,
    };
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

Text::UTX::Implementation::Parser::UTX::Simple - 

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
