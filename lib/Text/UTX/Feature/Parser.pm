package Text::UTX::Feature::Parser;


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


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'parser_class' => (
    is          => 'rw',
    isa         => 'Str',
    lazy_build  => 1,
    init_arg    => undef,
    trigger     => sub {
        $_[0]->clear_parser;
    },
);

has 'parser_version' => (
    is          => 'rw',
    isa         => 'Str',
    predicate   => 'has_parser_version',
    clearer     => 'clear_parser_version',
);

has 'parser' => (
    is          => 'rw',
    does        => 'Text::UTX::Interface::Parser',
    lazy_build  => 1,
    handles     => [qw(
        parse
    )],
);

# Note: this is a reserved attribute
has 'is_scrictly_parse' => (
    traits      => [qw(
        Bool
    )],
    is          => 'rw',
    isa         => 'Bool',
    default     => 0,
    handles     => {
        is_lazily_parse   => 'not',
        lazily_parse      => 'unset',
        strictly_parse    => 'set',
        toggle_parse_mode => 'toggle',
    },
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

sub _build_parser_class {
    my $self = shift;

    return $self->has_format_handler && ! $self->has_outstream
        ? $self->canonize_format_class(
            'Parser',
            'parser_version',
            $self->format_handler->fully_qualified_class_name('Parser'),
        )
        : $self->guess_format_class('Parser', 'parser_version', 'instream');
}

sub _build_parser_version {
    my $self = shift;

    confess 'Could not parse the lexicon as a proper format because: '
          . 'format handler is not defined'
        unless $self->has_format_handler;

    return $self->format_handler->version;
}

sub _build_parser {
    my $self = shift;

    $self->ensure_class_loaded($self->parser_class);

    return $self->parser_class->new(
        lines   => $self->loader->lines,
        version => $self->parser_version,
    );
}


# ****************************************************************
# public method(s)
# ****************************************************************

around parser_class => sub {
    my ($next, $self, $argument) = @_;

    if (defined $argument) {
        if ($argument !~ s{ \A \+ }{}xms) { # exclude explicitly assigned FQCN
            $argument = $self->canonize_format_class
                                ('Parser', 'parser_version', $argument);
        }
        return $self->$next($argument);
    }
    else {
        return $self->$next;
    }
};

around parse => sub {
    my ($next, $self, $parser_alias) = @_;

    $self->parser_class($parser_alias)
        if defined $parser_alias;

    my $universal_data = $self->$next;

    while (my ($attribute, $value) = each %$universal_data) {
        if ($self->meta->has_attribute($attribute)) {
            $self->$attribute($value);
        }
        else {
            warn sprintf "Lexicon has not the attribute that named (%s)\n",
                $attribute;
        }
    }

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

Text::UTX::Feature::Parser - Parser feature for Text::UTX

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
