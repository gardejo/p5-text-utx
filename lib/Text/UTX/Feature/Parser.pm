package Text::UTX::Feature::Parser;


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

use Text::UTX::Type::StrToArrayRef qw(StrToArrayRef);


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Try::Tiny;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'parser_class' => (
    is              => 'rw',
    isa             => 'Str',
    lazy_build      => 1,
    init_arg        => undef,
    trigger         => sub {
        $_[0]->clear_parser;
    },
    documentation   => '',
);

has 'parser_version' => (
    is              => 'rw',
    isa             => 'Str',
    predicate       => 'has_parser_version',
    clearer         => 'clear_parser_version',
    documentation   => '',
);

has 'parser' => (
    is              => 'rw',
    does            => 'Text::UTX::Interface::Parser',
    lazy_build      => 1,
    handles         => [qw(
        parse
    )],
    documentation   => '',
);

# Note: This attribute is reserved.
has 'is_strictly_parse' => (
    traits          => [qw(
        Bool
    )],
    is              => 'rw',
    isa             => 'Bool',
    default         => 0,
    handles         => {
        is_lazily_parse   => 'not',
        lazily_parse      => 'unset',
        strictly_parse    => 'set',
        toggle_parse_mode => 'toggle',
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

    confess 'Could not parse the lexicon as a proper format because '
          . 'format handler is not defined'
        unless $self->has_format_handler;

    return $self->format_handler->version;
}

sub _build_parser {
    my $self = shift;

    my $parser_class = $self->parser_class;

    try {
        $self->ensure_class_loaded($parser_class);
    }
    catch {
        confess sprintf 'Could not load the parser class (%s) because: %s',
                    $parser_class,
                    $_;
    };

    return $parser_class->new(
        lines   => $self->loader->lines,
        (
              $self->has_parser_version ? (version => $self->parser_version)
            :                             ()
        ),
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
    my ($next, $self, $lines) = @_;

    if (defined $lines) {
        $self->clear_instream;
        $self->loader_class('Text::UTX::Implementation::Loader::Memory');
        $self->loader->lines($lines);   # StrToArrayRef type coersion
    }

    my $parsed_data = $self->$next($self->loader->lines);

    while (my ($attribute, $value) = each %$parsed_data) {
        if ($self->meta->has_attribute($attribute)) {
            $self->$attribute($value);
        }
        else {
            warn sprintf "Lexicon has not the attribute that named (%s)\n",
                $attribute;
        }
    }

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

Text::UTX::Feature::Parser - Parser feature for Text::UTX

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
