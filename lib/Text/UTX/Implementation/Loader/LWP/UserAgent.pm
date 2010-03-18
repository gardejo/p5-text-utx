package Text::UTX::Implementation::Loader::LWP::UserAgent;


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

use Moose;
use MooseX::Types::URI qw(Uri);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Encode qw(encode_utf8);
use HTTP::Request::Common qw(GET);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

# Note: We should not consume roles at once.
with qw(
    Text::UTX::Implementation::Stream::LWP::UserAgent
    Text::UTX::Role::HasLines
);

with qw(
    Text::UTX::Role::Loadable
);

with qw(
    Text::UTX::Interface::Loader
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_lines {
    my $self = shift;

    my $request  = GET($self->stream);
    my $response = $self->agent->request($request);

    confess sprintf 'Could not download the file from (%s)',
                $self->stream->as_string
        if $response->is_error;

    my @lines = split m{\r?\n}xms, encode_utf8($response->decoded_content);

    return \@lines;
}


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


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

Text::UTX::Implementation::Loader::LWP::UserAgent - 

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
