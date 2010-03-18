package Text::UTX::Feature::Loader;


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
# general dependency(-ies)
# ****************************************************************

use Try::Tiny;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'loader_class' => (
    is              => 'rw',
    isa             => 'Str',
    lazy_build      => 1,
    init_arg        => undef,
    trigger         => sub {
        $_[0]->clear_loader;
        $_[0]->clear_parser_class;
        $_[0]->clear_parser_version;
        $_[0]->clear_parser;
    },
    documentation   => '',
);

has 'loader' => (
    is              => 'rw',
    does            => 'Text::UTX::Interface::Loader',
    lazy_build      => 1,
    handles         => [qw(
        load
    )],
    trigger         => sub {
        $_[0]->clear_parser_class;
        $_[0]->clear_parser_version;
        $_[0]->clear_parser;
    },
    documentation   => '',
);

has 'instream' => (
    is              => 'rw',
    isa             => 'Maybe[Str]',
    init_arg        => undef,
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_loader_class;
        $_[0]->clear_loader;
        $_[0]->clear_parser_class;
        $_[0]->clear_parser_version;
        $_[0]->clear_parser;
    },
    documentation   => '',
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Utility::Class
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_loader_class {
    my $self = shift;

    # return $self->has_stream_handler
    #     ? $self->stream_handler->fully_qualified_class_name('Loader')
    #     : $self->guess_stream_class('Loader', 'instream');
    return $self->guess_stream_class('Loader', 'instream');
}

sub _build_loader {
    my $self = shift;

    my $loader_class = $self->loader_class;

    try {
        $self->ensure_class_loaded($loader_class);
    }
    catch {
        confess sprintf 'Could not load the loader class (%s) because: %s',
                    $loader_class,
                    $_;
    };

    return $loader_class->new(
        stream => $self->instream,
    );
}

sub _build_instream {
    return;
}


# ****************************************************************
# public method(s)
# ****************************************************************

around loader_class => sub {
    my ($next, $self, $argument) = @_;

    if (defined $argument) {
        if ($argument !~ s{ \A \+ }{}xms) { # exclude explicitly assigned FQCN
            $argument = $self->canonize_stream_class('Loader', $argument);
        }
        return $self->$next($argument);
    }
    else {
        return $self->$next;
    }
};

around load => sub {
    my ($next, $self, $instream, $parser_alias) = @_;

    $self->instream($instream)
        if defined $instream;

    confess 'Could not load the instream because '
          . 'instream not defined'
        unless $self->has_instream;

    $self->$next;
    $self->parse($parser_alias);

    return $self;
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

Text::UTX::Feature::Loader - Loader feature for Text::UTX

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

Copyright (c) 2010 by MORIYA Masaki, alias Gardejo

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
