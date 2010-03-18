package Text::UTX::Implementation::Format::UTX::Simple;


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
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'count_header_lines' => (
    is              => 'ro',
    isa             => 'Int',
    lazy_build      => 1,
    documentation   => '',
);

# Note: I venture to define the type as 'Str' instead of 'Num' or 'Int'.
has 'abbreviation_for_specification' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    documentation   => '',
);

has 'comment_sign' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_comment_sign_pattern;
        $_[0]->comment_sign_for_dumper;
    },
    documentation   => '',
);

has 'comment_sign_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'comment_sign_for_dumper' => (
    is              => 'ro',
    isa             => 'Str',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'meta_information_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_meta_information_delimiter_pattern;
        $_[0]->clear_meta_information_delimiter_for_dumper;
    },
    documentation   => '',
);

has 'meta_information_delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'meta_information_delimiter_for_dumper' => (
    is              => 'ro',
    isa             => 'Str',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'alignment_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_alignment_delimiter_pattern;
    },
    documentation   => '',
);

has 'alignment_delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'locale_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    documentation   => '',
);

has 'format_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_format_delimiter_pattern;
    },
    documentation   => '',
);

has 'format_delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'miscellaniy_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_miscellaniy_delimiter_pattern;
        $_[0]->clear_miscellaniy_delimiter_for_dumper;
    },
    documentation   => '',
);

has 'miscellaniy_delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'miscellaniy_delimiter_for_dumper' => (
    is              => 'ro',
    isa             => 'Str',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'column_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_column_delimiter_pattern;
    },
    documentation   => '',
);

has 'column_delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'entry_delimiter' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    trigger         => sub {
        $_[0]->clear_entry_delimiter_pattern;
    },
    documentation   => '',
);

has 'entry_delimiter_pattern' => (
    is              => 'ro',
    isa             => 'RegexpRef',
    init_arg        => undef,
    lazy_build      => 1,
    documentation   => '',
);

has 'blank_entry' => (
    is              => 'ro',
    isa             => 'Str',
    lazy_build      => 1,
    documentation   => '',
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Role::FormatLike
    Text::UTX::Utility::Regexp
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_partly_qualified_class_name {
    return 'UTX::Simple';
}

sub _build_specification {
    return 'UTX Simple';
}

sub _build_latest_version {
    return '1.00';
}

sub _build_extension {
    return '.utx';
}

sub _build_uri {
    return 'http://www.aamt.info/english/utx/';
}

sub _build_count_header_lines {
    return 2;
}

sub _build_abbreviation_for_specification {
    return 'UTX-S';
}

sub _build_comment_sign {
    return '#';
}

sub _build_comment_sign_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces( $self->comment_sign );
}

sub _build_comment_sign_for_dumper {
    my $self = shift;

    # return $self->comment_sign
    #      . q{ };

    return $self->comment_sign;
}

sub _build_meta_information_delimiter {
    return ';';
}

sub _build_meta_information_delimiter_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces
                ( $self->meta_information_delimiter );
}

sub _build_meta_information_delimiter_for_dumper {
    my $self = shift;

    return $self->meta_information_delimiter
         . q{ };
}

sub _build_alignment_delimiter {
    return '/';
}

sub _build_alignment_delimiter_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces
                ( $self->alignment_delimiter );
}

sub _build_locale_delimiter {
    return '-';
}

sub _build_format_delimiter {
    return q{ };    # single space (0x20)
}

sub _build_format_delimiter_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces
                ( $self->format_delimiter );
}

sub _build_miscellaniy_delimiter {
    return ':';
}

sub _build_miscellaniy_delimiter_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces
                ( $self->miscellaniy_delimiter );
}

sub _build_miscellaniy_delimiter_for_dumper {
    my $self = shift;

    return $self->miscellaniy_delimiter
         . q{ };
}

sub _build_column_delimiter {
    return "\t";
}

sub _build_column_delimiter_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces
                ( $self->column_delimiter );
}

sub _build_entry_delimiter {
    return "\t";
}

sub _build_entry_delimiter_pattern {
    my $self = shift;

    return $self->assemble_regexp_with_affixed_spaces
                ( $self->entry_delimiter );
}

sub _build_blank_entry {
    return q{};
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub is_allowed_specification {
    my ($self, $specification) = @_;

    return defined $specification && (
                $specification eq $self->specification
             || $specification eq $self->abbreviation_for_specification
           );
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

Text::UTX::Implementation::Format::UTX::Simple - 

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
