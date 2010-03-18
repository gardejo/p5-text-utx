package Text::UTX::Implementation::Parser::UTX::Simple;


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
# general dependency(-ies)
# ****************************************************************

use Data::Util qw(:check);


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
    Text::UTX::Role::HasFormat
);

with qw(
    Text::UTX::Implementation::Format::UTX::Simple
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

# Note: We cannot write "has '+version' => (required => 1);" on this role
#       (from Moose 0.93_01).
around BUILDARGS => sub {
    my ($next, $class, @init_args) = @_;

    my $init_arg = $class->$next(@init_args);

    confess 'Could not construct the parser instance because '
          . 'version number must be specified'
        unless defined $init_arg->{version};

    return $init_arg;
};


# ****************************************************************
# public method(s)
# ****************************************************************

sub parse {
    my ($self, $lines) = @_;

    confess 'Could not parse lines because '
          . 'lines are not an array reference'
        unless is_array_ref($lines);

    # Note: Use slice instead of splice() to keep $self->loader->lines().
    my @header_lines = @$lines[0 .. ($self->count_header_lines - 1)];
    my @body_lines   = @$lines[$self->count_header_lines .. $#{$lines}];

    my $meta_information = $self->parse_header(\@header_lines);

    return {
        %$meta_information,
        columns => [ $self->all_universal_columns ],
        entries => $self->parse_body(\@body_lines),
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

=item MORIYA Masaki, alias Gardejo

C<< <moriya at cpan dot org> >>,
L<http://gardejo.org/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 by MORIYA Masaki, alias Gardejo

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
