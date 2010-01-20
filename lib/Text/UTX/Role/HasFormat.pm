package Text::UTX::Role::HasFormat;


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
# use Moose::Util qw(ensure_all_roles);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'format_class' => (
    is          => 'rw',
    isa         => 'Str',
    predicate   => 'has_format_class',
    trigger     => sub {
        $_[0]->clear_format;
    },
);

has 'format' => (
    is          => 'ro',
    does        => 'Text::UTX::Interface::Format',
    lazy_build  => 1,
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Utility::Class
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_format {
    my $self = shift;

    confess 'Could not instantiate format because: '
          . 'format class not defined'
        unless $self->has_format_class;

    $self->ensure_class_loaded($self->format_class);

    return $self->format_class->new;
}


# ****************************************************************
# public method(s)
# ****************************************************************

=for comment

sub apply_version {
    my ($self, $version) = @_;

    # ensure_all_roles $self->format, $self->version_for_class_name($version);

    return;
}

=cut


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

Text::UTX::Role::HasFormat - 

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
