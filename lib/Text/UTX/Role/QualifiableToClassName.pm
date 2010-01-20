package Text::UTX::Role::QualifiableToClassName;


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
# attribute(s)
# ****************************************************************

has 'namespace' => (
    is          => 'rw',
    isa         => 'Str',
    lazy_build  => 1,
);

has 'partly_qualified_class_name' => (
    is          => 'ro',
    isa         => 'Str',
    lazy_build  => 1,
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_namespace {
    return 'Text::UTX::Implementation';
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub fully_qualified_class_name {
    my ($self, $role_kind, $implementation) = @_;

    return join '::', (
        $self->namespace,
        $role_kind,
        ( $implementation || $self->partly_qualified_class_name ),
    );
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

Text::UTX::Role::QualifiableToClassName - 

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
