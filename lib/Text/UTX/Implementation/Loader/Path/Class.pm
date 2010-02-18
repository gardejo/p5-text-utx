package Text::UTX::Implementation::Loader::Path::Class;


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


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

# Note: We should not consume roles at once.
with qw(
    Text::UTX::Implementation::Stream::Path::Class
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

    # Note: We may simply implement this logic like
    #       "return $self->stream->slurp(chomp => 1);".

    my $handle = $self->stream->openr;

    confess sprintf 'Could not open the file (%s) as the read mode',
                $self->stream->stringify
        unless $handle;

    my @lines = $handle->getlines;
    confess sprintf 'Could not read lines from the file (%s)',
                $self->stream->stringify
        unless @lines;

    chomp @lines;
    $handle->close;

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

Text::UTX::Implementation::Loader::Path::Class - 

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
