package Text::UTX::Component::Locale;


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
use MooseX::StrictConstructor;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Type::Locale qw(LocaleString);
use Text::UTX::Type::Locale::Country qw(Country);
use Text::UTX::Type::Locale::Language qw(Language);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    MooseX::Clone
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'locale' => (
    is              => 'rw',
    isa             => LocaleString,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_language;
        $_[0]->clear_country;
    },
    documentation   => 'Locale code (alpha-2 language + alpha-2 country)',
);

has 'language' => (
    traits          => [qw(
        Clone
    )],
    is              => 'rw',
    isa             => Language,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_locale;
    },
    documentation   => 'Language code (alpha-2)',
);

has 'country' => (
    traits          => [qw(
        Clone
    )],
    is              => 'rw',
    isa             => Country,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_locale;
    },
    documentation   => 'Country code (alpha-2)',
);

has 'delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => 'Delimiter between language and country',
);

has 'delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => 'Delimiter pattern for analysis',
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_locale {
    return
        if ! $_[0]->has_language || ! defined $_[0]->language;

    return join $_[0]->delimiter, (
        lc $_[0]->language->code,
        ( $_[0]->has_country ? uc $_[0]->country->code : () ),
    );
}

sub _build_language {
    return
        if ! $_[0]->has_locale || ! defined $_[0]->locale;

    (my $language, undef) = split $_[0]->delimiter_pattern, $_[0]->locale;

    return $language;
}

sub _build_country {
    return
        if ! $_[0]->has_locale || ! defined $_[0]->locale;

    (undef, my $country) = split $_[0]->delimiter_pattern, $_[0]->locale;

    return $country;
}

sub _build_delimiter {
    return '_';
}

sub _build_delimiter_pattern {
    return qr{ [\-_] }xms;
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

Text::UTX::Component::Locale - 

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
