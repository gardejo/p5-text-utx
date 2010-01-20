package Text::UTX::Role::LexiconLike;


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
use MooseX::Types::DateTimeX qw(DateTime);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use DateTime;
use List::MoreUtils qw(first_index);


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Type::Alignment qw(Alignment);
use Text::UTX::Type::IxHash qw(IxHash);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'alignment' => (
    is          => 'rw',
    isa         => Alignment,
    coerce      => 1,
    handles     => [qw(
        clear_source
        clear_target
        has_source
        has_target
        source
        target
    )],
);

has 'last_modified' => (
    is          => 'rw',
    isa         => DateTime,
    coerce      => 1,
    lazy_build  => 1,
);

has 'miscellanies' => (
    is          => 'rw',
    isa         => IxHash,
    coerce      => 1,
    handles     => {
        add_miscellanies  => 'Push',
        add_miscellany    => 'Push',
        all_miscellanies  => 'Keys',
        exists_miscellany => 'EXISTS',
        get_miscellany    => 'FETCH',
        has_miscellany    => 'EXISTS',
    },
    # default     => sub {
    #     [];
    # },
    lazy_build  => 1,
);

has 'columns' => (
    traits      => [qw(
        Array
    )],
    is          => 'rw',
    isa         => 'ArrayRef[Str]',
    handles     => {
        add_column    => 'push',
        add_columns   => 'push',
        all_columns   => 'elements',
        count_columns => 'count',
        get_column    => 'get',
    },
);

has 'entries' => (
    traits      => [qw(
        Array
    )],
    is          => 'rw',
    isa         => 'ArrayRef[HashRef]',
    handles     => {
        add_entries    => 'push',
        add_entry      => 'push',
        all_entries    => 'elements',
        clear_entries  => 'clear',
        count_entries  => 'count',
        delete_entry   => 'delete',
        filter_entries => 'grep',
        get_entry      => 'get',
        has_entries    => 'count',
        has_no_entries => 'is_empty',
        insert_entry   => 'insert',
        map_entries    => 'map',
    },
    trigger     => sub {
        $_[0]->clear_index;
    },
);

has 'index' => (
    is          => 'ro',
    isa         => 'HashRef[Int]',
    init_arg    => undef,
    lazy_build  => 1,
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_last_modified {
    # Note: I venture use quated 'DateTime'
    #       for to distinguish the class name to the type constraint
    return 'DateTime'->now(time_zone => 'local');
}

sub _build_miscellanies {
    return [];
}

sub _build_index {
    confess __PACKAGE__ . '::_build_index() did not implemented yet';
}


# ****************************************************************
# public method(s)
# ****************************************************************

# Todo: memoize it!
sub find_column {
    my ($self, $column_name) = @_;

    return first_index {
        $_ eq $column_name;
    } $self->all_columns;
}

sub consult {
    # Todo: using index
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

Text::UTX::Role::StreamLike - 

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
