package Text::UTX::Implementation::Dumper::UTX::Simple;


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

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'are_blank_columns_drew' => (
    traits          => [qw(
        Bool
    )],
    is              => 'rw',
    default         => 1,
    handles         => {
        draw_blank_columns        => 'set',
        ignore_blank_columns      => 'unset',
        are_ignored_blank_columns => 'not',
    },
    documentation   => '',
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

#    Text::UTX::Role::HasColumns
with qw(
    Text::UTX::Interface::Dumper
    Text::UTX::Role::HasLines
    Text::UTX::Role::HasFormat
    Text::UTX::Role::LexiconLike
    Text::UTX::Implementation::Format::UTX::Simple
);


# ****************************************************************
# inherited attribute(s)
# ****************************************************************

has '+lines' => (
    lazy_build  => 1,
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

sub BUILD {
    my $self = shift;

    my $format_class = $self->fully_qualified_class_name('Format');
    if ($self->has_version) {
        $format_class .= '::'
                      .  $self->version_for_class_name( $self->version );
    }

    $self->format_class($format_class);

    return;
}


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_lines {
    return [];
}


# ****************************************************************
# public method(s)
# ****************************************************************

sub dump {
    my $self = shift;

    my $header_lines = $self->dump_header;
    my $body_lines   = $self->dump_body;

    $self->add_lines(@$header_lines, @$body_lines);

    # Note: Adding "\n" to the last line.
    $self->add_line(q{});

    return $self->as_string;
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

Text::UTX::Implementation::Dumper::UTX::Simple - 

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
