package Text::UTX::Implementation::Handler::Format::UTX::XML;


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
# general dependency(-ies)
# ****************************************************************

use List::MoreUtils qw(apply);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Role::Handlable
    Text::UTX::Implementation::Format::UTX::XML
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_aliases {
    my @aliases = qw(UTX-XML);
    @aliases = ( @aliases, apply { $_ =~ s{-}{ }xmsg } @aliases );

    return \@aliases;
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub guess {
    my ($self, $role_kind, $framework, $stream) = @_;

    return
        if defined $stream && $stream !~ $self->extension_pattern;

    my $first_line = $framework->loader->get_line(0);

    return
        if $first_line =~ m{ \A }xms;   # Note: Anything match with the pattern.

    $self->_guess_version($first_line);

    return $self->fully_qualified_class_name($role_kind);
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _guess_version {
    my ($self, $first_line) = @_;

    my $version;

    # Todo: implement it
    # ...

    $version = $self->latest_version
        unless defined $version;

    $self->version($version);

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

Text::UTX::Implementation::Handler::Format::UTX::XML - 

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
