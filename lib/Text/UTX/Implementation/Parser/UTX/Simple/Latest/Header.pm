package Text::UTX::Implementation::Parser::UTX::Simple::Latest::Header;


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

sub parse_header {
    my ($self, $header_lines) = @_;

    # Todo: To associate with $self->count_header_lines().
    my $meta_information = $self->_parse_meta_information($header_lines->[0]);
    $self->_parse_columns($header_lines->[1]);

    return $meta_information;
}


# ****************************************************************
# protected/private method(s): parser(s)
# ****************************************************************

sub _parse_meta_information {
    my ($self, $meta_line) = @_;

    $self->_canonize_line(\$meta_line);
    my @informations
        = split $self->format->meta_information_delimiter_pattern, $meta_line;

    my $format        = shift @informations;
    my $alignment     = shift @informations;
    my $last_modified = shift @informations;

    $self->_parse_format($format);

    return {
        alignment     => $self->_parse_alignment($alignment),
        last_modified => $last_modified,
        miscellanies  => $self->_parse_miscellanies(\@informations),
    };
}

sub _parse_format {
    my ($self, $format) = @_;

    my ($specification, $version)
        = split $self->format->format_delimiter_pattern, $format;

    $specification = q{} unless defined $specification;
    $version       = q{} unless defined $version;

    # Note: This exception will happen only by a parser object
    #       (Text::UTX::Implementation::Parser::UTX::Simple::*).
    #       The container object (Text::UTX) throws the different exception
    #       ('Could not guess a parser class name for instream').
    confess sprintf 'Could not parse a format because '
                  . 'parsed specification name (%s) is not (%s)',
                $specification,
                $self->specification
        unless $self->is_allowed_specification($specification);

    confess sprintf 'Could not parse a format because '
                  . 'parsed version number (%s) is not (%s)',
                $version,
                $self->version
        if $version ne $self->version;

    return;
}

sub _parse_alignment {
    my ($self, $alignment) = @_;

    # my $locale_delimiter = $self->format->locale_delimiter;
    # my ($source, $target) = apply {
    #     $_ =~ s{$locale_delimiter}{_};  # canonize
    # } split $self->format->alignment_delimiter_pattern, $alignment, 2;

    my ($source, $target)
        = split $self->format->alignment_delimiter_pattern, $alignment, 2;

    my %alignment = (
        source => $source,
        ( defined $target ? (target => $target) : () ),
    );

    map {
        confess sprintf 'Could not parse an alignment because '
                      . 'the %s language is the blank character',
                    $_
            if defined $alignment{$_} && $alignment{$_} eq q{};
    } qw(source target);

    return \%alignment;
}

sub _parse_miscellanies {
    my ($self, $miscellanies_ref) = @_;

    # Note: I venture to use an @array instead of a %hash for Tie::IxHash
    my @miscellanies;
    foreach my $miscellany (@$miscellanies_ref) {
        push @miscellanies,
            split $self->format->miscellaniy_delimiter_pattern, $miscellany;
    }

    return \@miscellanies;
}

sub _parse_columns {
    my ($self, $column_line) = @_;

    $self->_canonize_line(\$column_line);
    my @native_columns
        = split $self->format->column_delimiter_pattern, $column_line;

    my @universal_columns = apply {
        $_ =~ s{ \A src (?= : | \z ) }{source}xms;
        $_ =~ s{ \A tgt (?= : | \z ) }{target}xms;
        $_ =~ s{            :        }{_}xmsg;
    } @native_columns;

    # Note: Use @alignments instead of %alignment
    #       to associate it with indexed hash (Tie::IxHash).
    my @alignments = mesh @universal_columns, @native_columns;

    $self->set_columns(@alignments);

    return;
}


# ****************************************************************
# protected/private method(s): utility(-ies)
# ****************************************************************

sub _canonize_line {
    my ($self, $string_ref) = @_;

    if ( $$string_ref !~ s{ \A \# }{}xms ) {
        # Note: This exception will happen only by a parser object
        #       (Text::UTX::Implementation::Parser::UTX::Simple::*).
        #       The container object (Text::UTX) throws the different exception
        #       ('Could not guess a parser class name for instream').
        confess 'Could not parse the header because '
              . 'comment sign does not exist';
    }

    return;
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

Text::UTX::Implementation::Parser::UTX::Simple::Latest::Header - 

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
