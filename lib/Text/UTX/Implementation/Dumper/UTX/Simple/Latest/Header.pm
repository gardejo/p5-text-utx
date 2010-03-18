package Text::UTX::Implementation::Dumper::UTX::Simple::Latest::Header;


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

use List::MoreUtils qw(apply mesh);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Utility::Class
);


# ****************************************************************
# public method(s)
# ****************************************************************

sub dump_header {
    my $self = shift;

    my @meta_information = $self->_dump_meta_information;
    my @columns          = $self->_dump_columns;

    return [ @meta_information, @columns ];
}


# ****************************************************************
# protected/private method(s): dumper(s)
# ****************************************************************

sub _dump_meta_information {
    my $self = shift;

    return $self->format->comment_sign_for_dumper
         . (
            join $self->format->meta_information_delimiter_for_dumper, (
                $self->_dump_format,
                $self->_dump_alignment,
                $self->_dump_last_modified,
                $self->_dump_miscellanies,
            )
         );
}

sub _dump_format {
    my $self = shift;

    return join $self->format->format_delimiter, (
        $self->abbreviation_for_specification,
        $self->version,
    );
}

sub _dump_last_modified {
    my $self = shift;

    my $offset = $self->last_modified->time_zone->is_utc
        ? 'Z'
        : $self->last_modified->strftime('%z');

    # Note: +09:00 is invalid (+0900 is valid).
    return $self->last_modified->iso8601 . $offset;
}

sub _dump_alignment {
    my $self = shift;

    my $locale_delimiter = $self->format->locale_delimiter;

    return join $self->format->alignment_delimiter, (
        apply {
            $_ =~ s{_}{$locale_delimiter};  # specialize
        } (
            $self->source->locale,
            (
                $self->has_target ? $self->target->locale : ()
            ),
        )
    );
}

sub _dump_miscellanies {
    my $self = shift;

    my @miscellanies;
    foreach my $miscellany_kind ($self->all_miscellanies) {
        push @miscellanies,
            join $self->miscellaniy_delimiter_for_dumper, (
                $miscellany_kind,
                $self->get_miscellany($miscellany_kind),
            );
    }

    return @miscellanies;
}

sub _dump_columns {
    my $self = shift;

    my @universal_columns = $self->all_columns;
    my @native_columns = apply {
        $_ =~ s{ \A source (?= _ | \z ) }{src}xms;
        $_ =~ s{ \A target (?= _ | \z ) }{tgt}xms;
        $_ =~ s{               _        }{:}xmsg;
    } @universal_columns;

    return $self->format->comment_sign_for_dumper
         . (
            join $self->format->column_delimiter, @native_columns
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

Text::UTX::Implementation::Dumper::UTX::Simple::Latest::Header - 

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
