package Text::UTX::Role::FormatLike;


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
use MooseX::Types::URI qw(Uri);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'specification' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    documentation   => 'name of lexicon specification',
);

has 'version' => (
    is              => 'rw',
    isa             => 'Str',
    lazy_build      => 1,
    documentation   => 'version of lexicon specification',
);

has 'latest_version' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
);

has 'extension' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_extension_pattern;
    },
    documentation   => 'an extension of an UTX Simple lexicon file',
);

has 'extension_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
);

# Caveat: this attribute IS NOT a location of an user's lexicon
has 'uri' => (
    is              => 'ro',
    isa             => Uri,
    coerce          => 1,
    lazy_build      => 1,
    documentation   => 'URI that specifies specification about lexicon',
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Role::QualifiableToClassName
    Text::UTX::Interface::Format
    Text::UTX::Utility::Regexp
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_extension_pattern {
    my $self = shift;

    my $extension = $self->escape_meta_characters_of_regexp($self->extension);

    return qr{ $extension \z }xms;
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

Text::UTX::Role::FormatLike - 

=head1 SYNOPSIS

    package Text::UTX::Implementation::Format::MyFormat;

    with qw(
        Text::UTX::Role::FormatLike
    );

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
