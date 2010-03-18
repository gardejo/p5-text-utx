package Text::UTX::Utility::Class::Finder;


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
use Moose::Util qw(does_role);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use List::MoreUtils qw(first_index);
use Module::Pluggable::Object;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'namespace' => (
    is              => 'rw',
    isa             => 'Str',
    required        => 1,
    documentation   => '',
);

has 'interface' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    documentation   => '',
);

has 'fallback' => (
    is              => 'ro',
    isa             => 'Str',
    predicate       => 'has_fallback',
    trigger         => sub {
        $_[0]->clear_handlers;
    },
    documentation   => '',
);

has 'handlers' => (
    traits          => [qw(
        Array
    )],
    is              => 'ro',
    isa             => 'ArrayRef[Object]',
    lazy_build      => 1,
    handles         => {
        all_handlers => 'elements',
        add_handler  => 'unshift',      # Note: I venture to assign 'push'.
    },
    documentation   => '',
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_interface {
    return 'Text::UTX::Interface::Handler';
}

sub _build_handlers {
    my $self = shift;

    my @handler_classes = grep {
        does_role $_, $self->interface;
    } Module::Pluggable::Object->new(
        search_path => $self->namespace,
        require     => 1,
    )->plugins;

    if ($self->has_fallback) {
        my $fallback_index = first_index {
            $_ eq $self->fallback;
        } @handler_classes;

        if ($fallback_index == -1) {
            push @handler_classes, $self->fallback;
        }
        elsif ($fallback_index != $#handler_classes) {
            my $fallback = splice @handler_classes, $fallback_index, 1;
            push @handler_classes, $fallback;
        }
    }

    my @handlers = map {
        $_->new;
    } @handler_classes;

    return \@handlers;
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

Text::UTX::Utility::Class::Finder - Class finder for Text::UTX

=head1 SYNOPSIS

    package Text::UTX::Feature::Handler;

    use Text::UTX::Utility::Class::Finder;

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
