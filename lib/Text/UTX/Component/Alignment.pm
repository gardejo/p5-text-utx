package Text::UTX::Component::Alignment;


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

use Text::UTX::Type::Locale qw(Locale);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'alignment' => (
    is          => 'rw',
    isa         => 'Str',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_source;
        $_[0]->clear_target;
    },
);

has 'source' => (
    is          => 'rw',
    isa         => Locale,
    coerce      => 1,
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_alignment;
    },
);

has 'target' => (
    is          => 'rw',
    isa         => Locale,
    coerce      => 1,
    # lazy_build  => 1,
    predicate   => 'has_target',
    clearer     => 'clear_target',
    trigger     => sub {
        $_[0]->clear_alignment;
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
            source => $init_args[0]->[0],
            ( defined $init_args[0]->[1]
                ? ( target => $init_args[0]->[1] ) : () )
        )
        : ref $init_args[0] eq 'HASH'   ? (
            source => $init_args[0]->{source},
            ( defined $init_args[0]->{target}
                ? ( target => $init_args[0]->{target} ) : () )
        )
        : ref $init_args[0] eq 'SCALAR' ? ( alignment => ${ $init_args[0] } )
        : ref $init_args[0] eq q{}      ? ( alignment =>    $init_args[0]   )
        :                                 @init_args
    );
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_alignment {
    my $self = shift;

    return join '/', (
        $self->source->locale,
        ( $self->has_target ? $self->target->locale : () ),
    );
}

sub _build_source {
    my $self = shift;

    my ($source, $target) = split m{ / }xms, $self->alignment;

    return $source;
}

# sub _build_target {
#     my $self = shift;
# 
#     my ($source, $target) = split m{ / }xms, $self->alignment;
# 
#     return
#         unless defined $target;
#     return $target;
# }

around target => sub {
    my ($next, $self, $argument) = @_;

    # setter
    return $self->$next($argument)
        if defined $argument;

    # getter : already exists
    return $self->$next
        if $self->has_target;

    # getter : lazy building
    my ($source, $target) = split m{ / }xms, $self->alignment;

    return
        unless defined $target;

    return $self->$next( $target );
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

Text::UTX::Component::Alignment - 

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
