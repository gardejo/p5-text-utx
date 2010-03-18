package Text::UTX::Component::Alignment;


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

use Text::UTX::Type::Locale qw(Locale);


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

has 'alignment' => (
    is              => 'ro',
    isa             => 'Maybe[Str]',
    lazy_build      => 1,
    init_arg        => undef,
    documentation   => 'String of source/target alignment',
);

has 'source' => (
    traits          => [qw(
        Clone
    )],
    is              => 'rw',
    isa             => Locale,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_alignment;
    },
    documentation   => 'String of source locale',
);

has 'target' => (
    traits          => [qw(
        Clone
    )],
    is              => 'rw',
    isa             => Locale,
    coerce          => 1,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_alignment;
    },
    documentation   => 'String of target locale',
);

has 'delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => 'Delimiter string between source and target',
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

sub _build_alignment {
    return
        if ! $_[0]->has_source || ! defined $_[0]->source;

    return join $_[0]->delimiter, (
        $_[0]->source->locale,
        ( $_[0]->has_target ? $_[0]->target->locale : () ),
    );
}

sub _build_source {
    return
        if ! $_[0]->has_alignment || ! defined $_[0]->alignment;

    (my $source, undef) = split $_[0]->delimiter, $_[0]->alignment;

    return $source;
}

sub _build_target {
    return
        if ! $_[0]->has_alignment || ! defined $_[0]->alignment;

    (undef, my $target) = split $_[0]->delimiter, $_[0]->alignment;

    return $target;
}

sub _build_delimiter {
    return '/';
}

sub _build_delimiter_pattern {
    return qr{ / }xms;
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

Text::UTX::Component::Alignment - 

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
