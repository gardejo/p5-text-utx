package Text::UTX::Implementation::Handler::Stream::LWP::UserAgent;


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
# attribute(s)
# ****************************************************************



# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Implementation::Stream::LWP::UserAgent
    Text::UTX::Role::Handlable
    Text::UTX::Role::HasLines
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_aliases {
    return [qw(
        LWP
        LWP::UserAgent
        Network
    )];
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub guess {
    my ($self, $role_kind, $framework, $stream) = @_;

    # Note: This pattern allows 'file:///path/to/lexicon/example.utx' format.
    return
        if $stream !~ m{ :// }xms;

    return $self->fully_qualified_class_name($role_kind);
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

Text::UTX::Implementation::Handler::Stream::LWP::UserAgent - 

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
