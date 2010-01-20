package Text::UTX::Implementation::Saver::Path::Class;


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

use Moose;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Role::HasLines
    Text::UTX::Implementation::Stream::Path::Class
);

# method(s)
with qw(
    Text::UTX::Role::Loadable
);

# interface(s)
with qw(
    Text::UTX::Interface::Saver
);


# ****************************************************************
# public method(s)
# ****************************************************************

sub save {
    my ($self, $outstream, $dumped_string) = @_;

    if (defined $outstream) {
        $self->stream($outstream);
    }

    my $handle = $self->stream->openw;

    confess sprintf 'Could not open file (%s) as write mode',
                $self->stream->stringify
        unless $handle;

    $handle->print( $dumped_string )
        or confess sprintf 'Could not write lines to file (%s)',
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
