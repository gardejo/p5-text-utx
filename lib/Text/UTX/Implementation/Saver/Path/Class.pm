package Text::UTX::Implementation::Saver::Path::Class;


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
);

with qw(
    Text::UTX::Interface::Saver
);


# ****************************************************************
# public method(s)
# ****************************************************************

sub save {
    my ($self, $outstream, $dumped_string) = @_;

    $self->stream($outstream)
        if defined $outstream;

    my $handle = $self->stream->openw;

    confess sprintf 'Could not open the file (%s) as the write mode',
                $self->stream->stringify
        unless $handle;

    $handle->print( $dumped_string )
        or confess sprintf 'Could not write lines to the file (%s)',
                        $self->stream->stringify;

    $handle->close;

    return;
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

Text::UTX::Implementation::Saver::Path::Class - 

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
