package Text::UTX::Component::Locale;


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
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Type::Locale::Country qw(Country);
use Text::UTX::Type::Locale::Language qw(Language);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'locale' => (
    is          => 'rw',
    isa         => 'Str',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_language;
        $_[0]->clear_country;
    },
);

has 'language' => (
    is          => 'rw',
    isa         => Language,
    coerce      => 1,
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_locale;
    },
);

has 'country' => (
    is          => 'rw',
    isa         => Country,
    coerce      => 1,
    # lazy_build  => 1,
    predicate   => 'has_country',
    clearer     => 'clear_country',
    trigger     => sub {
        $_[0]->clear_locale;
    },
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @init_args) = @_;

    return $class->$next(
          scalar @init_args != 1        ? @init_args
        : ref $init_args[0] eq 'ARRAY'  ? (
            language => $init_args[0]->[0],
            ( defined $init_args[0]->[1]
                ? ( country => $init_args[0]->[1] ) : () )
        )
        : ref $init_args[0] eq 'HASH'   ? (
            language => $init_args[0]->{language},
            ( defined $init_args[0]->{country}
                ? ( country => $init_args[0]->{country} ) : () )
        )
        : ref $init_args[0] eq 'SCALAR' ? ( locale => ${ $init_args[0] } )
        : ref $init_args[0] eq q{}      ? ( locale =>    $init_args[0]   )
        :                                 @init_args
    );
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_locale {
    my $self = shift;

    return join '_', (
        lc $self->language->code,
        ( $self->has_country ? uc $self->country->code : () ),
    );
}

sub _build_language {
    my $self = shift;

    my ($language, $country) = split m{ [\-_] }xms, $self->locale;

    return $language;
}

# sub _build_country {
#     my $self = shift;
# 
#     my ($language, $country) = split m{ [\-_] }xms, $self->locale;
# 
#     return
#         unless defined $country;
#     return $country;
# }

around country => sub {
    my ($next, $self, $argument) = @_;

    # setter
    return $self->$next($argument)
        if defined $argument;

    # getter : already exists
    return $self->$next
        if $self->has_country;

    # getter : lazy building
    my ($language, $country) = split m{ [\-_] }xms, $self->locale;

    return
        unless defined $country;

    return $self->$next($country);
};


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

Text::UTX::Component::Locale - 

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
