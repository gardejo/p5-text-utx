package Text::UTX::Implementation::Handler::Stream::Path::Class;


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
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Utility::Class;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Implementation::Stream::Path::Class
    Text::UTX::Role::Handlable
    Text::UTX::Role::HasLines
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_aliases {
    return [qw(
        Path::Class
        Local
    )];
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub guess {
    my ($self, $role_kind, $framework, $stream) = @_;

    return
        unless defined $stream;

    $self->_optimize;

    return $self->fully_qualified_class_name($role_kind);
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _optimize {
    my $invocant  = shift;

    Text::UTX::Utility::Class->ensure_class_loaded('File::Spec::Memoized');

    # and more ...

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

Text::UTX::Implementation::Handler::Stream::Path::Class - 

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
