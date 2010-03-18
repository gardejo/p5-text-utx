package Text::UTX::Feature::Saver;


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

has 'saver_class' => (
    is              => 'rw',
    isa             => 'Str',
    lazy_build      => 1,
    init_arg        => undef,
    trigger         => sub {
        $_[0]->clear_saver;
    },
    documentation   => '',
);

has 'saver' => (
    is              => 'rw',
    does            => 'Text::UTX::Interface::Saver',
    lazy_build      => 1,
    handles         => [qw(
        save
    )],
    documentation   => '',
);

has 'outstream' => (
    is              => 'rw',
    isa             => 'Str',
    init_arg        => undef,
    predicate       => 'has_outstream',
    trigger         => sub {
        $_[0]->clear_saver_class;
        $_[0]->clear_saver;
        $_[0]->clear_dumper_class;
        $_[0]->clear_dumper_version;
        $_[0]->clear_dumper;
    },
    documentation   => '',
);

# Note: This attribute is reserved.
has 'is_implicitly_save' => (
    traits          => [qw(
        Bool
    )],
    is              => 'rw',
    isa             => 'Bool',
    default         => 1,
    handles         => {
        is_explicitly_save => 'not',
        explicitly_save    => 'unset',
        implicitly_save    => 'set',
        toggle_save_mode   => 'toggle',
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

sub _build_saver_class {
    my $self = shift;

    # return $self->has_stream_handler
    #     ? $self->stream_handler->fully_qualified_class_name('Saver')
    #     : $self->guess_stream_class('Saver', 'outstream');
    return $self->guess_stream_class('Saver', 'outstream');
}

sub _build_saver {
    my $self = shift;

    my $saver_class = $self->saver_class;

    try {
        $self->ensure_class_loaded($saver_class);
    }
    catch {
        confess sprintf 'Could not load the saver class (%s) because: %s',
                    $saver_class,
                    $_;
    };

    return $saver_class->new(
        stream => $self->outstream,
    );
}


# ****************************************************************
# public method(s)
# ****************************************************************

around saver_class => sub {
    my ($next, $self, $argument) = @_;

    if (defined $argument) {
        if ($argument !~ s{ \A \+ }{}xms) { # exclude explicitly assigned FQCN
            $argument = $self->canonize_stream_class('Saver', $argument);
        }
        return $self->$next($argument);
    }
    else {
        return $self->$next;
    }
};

around save => sub {
    my ($next, $self, $outstream, $dumper_alias) = @_;

    my $dumper_version = $self->dumper_version;
    $self->outstream($outstream)
        if defined $outstream;
    $self->dumper_version($dumper_version);

    $dumper_alias = $self->parser->partly_qualified_class_name
        if ! $dumper_alias
        && $self->has_parser;

    if (! $self->has_outstream) {
        confess 'Could not save the outstream because '
              . 'outstream not defined'
            if $self->is_explicitly_save;

        $self->outstream( $self->instream );    # overwite to instream
    }

    $self->$next(
        $self->outstream,
        $self->dump($dumper_alias),
    );

    return;
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

Text::UTX::Feature::Saver - Saver feature for Text::UTX

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
