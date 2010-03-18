package Text::UTX::Component::Locale::Language;


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
use MooseX::Types::Locale::Language qw(LanguageCode LanguageName);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Locale::Language qw(code2language language2code);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    MooseX::Clone
);


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'code' => (
    is              => 'rw',
    isa             => LanguageCode,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_name;
    },
    documentation   => 'Language code (ISO 639-1 alpha-2)',
);

has 'name' => (
    is              => 'rw',
    isa             => LanguageName,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_code;
    },
    documentation   => 'Language name (ISO 639-1)',
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_code {
    return language2code $_[0]->name;
}

sub _build_name {
    return code2language $_[0]->code;
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

Text::UTX::Component::Locale::Language - 

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
