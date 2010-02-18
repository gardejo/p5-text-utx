package Text::UTX::Feature::Handler;


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
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Utility::Class::Finder;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'stream_finder' => (
    is          => 'rw',
    isa         => 'Text::UTX::Utility::Class::Finder',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_stream_handler;
    },
);

has 'stream_handler' => (
    is          => 'rw',
    does        => 'Text::UTX::Interface::Handler',
    init_arg    => undef,
    predicate   => 'has_stream_handler',
    writer      => '_set_stream_handler',
    clearer     => 'clear_stream_handler',
);

has 'format_finder' => (
    is          => 'rw',
    isa         => 'Text::UTX::Utility::Class::Finder',
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_format_handler;
    },
);

has 'format_handler' => (
    is          => 'rw',
    does        => 'Text::UTX::Interface::Handler',
    init_arg    => undef,
    predicate   => 'has_format_handler',
    writer      => '_set_format_handler',
    clearer     => 'clear_format_handler',
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Utility::Class
    Text::UTX::Role::QualifiableToClassName
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_stream_finder {
    my $self = shift;

    return Text::UTX::Utility::Class::Finder->new(
        namespace => $self->fully_qualified_class_name
                                ('Handler', 'Stream'),
        fallback  => $self->fully_qualified_class_name
                                ('Handler', 'Stream::Memory'),
    );
}

sub _build_format_finder {
    my $self = shift;

    return Text::UTX::Utility::Class::Finder->new(
        namespace => $self->fully_qualified_class_name
                                ('Handler', 'Format'),
    );
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub canonize_stream_class {
    my ($self, $role_kind, $alias) = @_;

    return $self->_query_concrete_class(
        'canonize', 'stream', $role_kind, 'alias', $alias
    );
}

sub guess_stream_class {
    my ($self, $role_kind, $stream_kind) = @_;

    return $self->_query_concrete_class(
        'guess', 'stream', $role_kind, $stream_kind, $self->$stream_kind
    );
}

sub canonize_format_class {
    my ($self, $role_kind, $version_kind, $alias) = @_;

    return $self->_query_format_class(
        'canonize', $role_kind, 'alias', $alias, $version_kind
    );
}

sub guess_format_class {
    my ($self, $role_kind, $version_kind, $stream_kind) = @_;

    return $self->_query_format_class(
        'guess', $role_kind, $stream_kind, $self->$stream_kind, $version_kind
    );
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

# Note: This is the Chain of Responsibility pattern.
sub _query_concrete_class {
    my ($self, $query_method, $responsibility, $role_kind, $seed_kind, $seed)
        = @_;

    my $responsibility_finder = $responsibility . '_finder';

    my $concrete_class;

    HANDLER:
    foreach my $handler ($self->$responsibility_finder->all_handlers) {
        $concrete_class = $handler->$query_method($role_kind, $self, $seed);
        if ($concrete_class) {
            my $handler_writer = '_set_' . $responsibility . '_handler';
            $self->$handler_writer($handler);
            last HANDLER;
        }
    }

    confess sprintf 'Could not %s the %s class name for %s (%s)',
                $query_method,
                lc $role_kind,
                $seed_kind,
                $seed || ''
        unless $concrete_class;

    return $concrete_class;
}

sub _query_format_class {
    my ($self, $query_method, $role_kind, $seed_kind, $seed, $version_kind)
        = @_;

    my $format_class = $self->_query_concrete_class(
        $query_method, 'format', $role_kind, $seed_kind, $seed
    );

    if ($self->format_handler->has_version) {
        $self->$version_kind( $self->format_handler->version );
        $format_class .= '::'
                      . $self->version_for_class_name( $self->$version_kind );
    }

    return $format_class;
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

Text::UTX::Feature::Handler - Class handler feature for Text::UTX

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

Copyright (c) 2010 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com/>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
