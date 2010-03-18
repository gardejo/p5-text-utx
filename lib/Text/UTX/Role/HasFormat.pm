package Text::UTX::Role::HasFormat;


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
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'format_class' => (
    is              => 'rw',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_format;
    },
    documentation   => '',
);

has 'format' => (
    is              => 'ro',
    does            => 'Text::UTX::Interface::Format',
    lazy_build      => 1,
    documentation   => '',
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Utility::Class
);


# ****************************************************************
# interface(s)
# ****************************************************************

# Fixme:
# requires qw(
#     version
# );


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_format_class {
    my $self = shift;

    my $format_class = $self->fully_qualified_class_name('Format');
    $format_class .= '::' . $self->version_for_class_name($self->version)
        if defined $self->version;

    return $format_class;
}

sub _build_format {
    my $self = shift;

    confess 'Could not instantiate the format because '
          . 'the format class not defined'
        unless defined $self->format_class;

    $self->ensure_class_loaded($self->format_class);

    return $self->format_class->new;
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

Text::UTX::Role::HasFormat - 

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head1 MEMORANDUM

If we apply a role for a class
by L<Moose::Util::ensure_all_roles()|Moose::Util> dynamically,
the applied class change into an anonymous class.
Therefore, I implemented B<version> classes and B<format> roles
(instead of B<format> classes and B<version> roles).

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
