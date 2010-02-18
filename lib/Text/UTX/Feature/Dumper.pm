package Text::UTX::Feature::Dumper;


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
# general dependency(-ies)
# ****************************************************************

use Storable qw(dclone);


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

has 'dumper_class' => (
    is          => 'rw',
    isa         => 'Str',
    init_arg    => undef,
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_dumper;
    },
);

has 'dumper_version' => (
    is          => 'rw',
    isa         => 'Str',
    predicate   => 'has_dumper_version',
    clearer     => 'clear_dumper_version',
);

has 'dumper' => (
    is          => 'rw',
    does        => 'Text::UTX::Interface::Dumper',
    # init_arg    => undef,
    lazy_build  => 1,
    handles     => [qw(
        dump
    )],
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

sub _build_dumper_class {
    my $self = shift;

    return $self->has_format_handler && ! $self->has_outstream
        ? $self->canonize_format_class(
            'Dumper',
            'dumper_version',
            $self->format_handler->fully_qualified_class_name('Dumper'),
        )
        : $self->guess_format_class('Dumper', 'dumper_version', 'outstream');
}

sub _build_dumper_version {
    my $self = shift;

    confess 'Could not dump the lexicon as a proper format because '
          . 'format handler is not defined'
        unless $self->has_format_handler;

    return $self->format_handler->version;
}

sub _build_dumper {
    my $self = shift;

    my $dumper_class = $self->dumper_class;

    try {
        $self->ensure_class_loaded($self->dumper_class);
    }
    catch {
        confess sprintf 'Could not load the dumper class (%s) because: %s',
                    $dumper_class,
                    $_;
    };

    return $dumper_class->new(
        version       => $self->dumper_version,
        alignment     => dclone $self->alignment,
        # last_modified => dclone $self->last_modified,
        miscellanies  => dclone $self->miscellanies,
        columns       => dclone $self->columns,
        entries       => dclone $self->entries,
    );
}


# ****************************************************************
# public method(s)
# ****************************************************************

around dumper_class => sub {
    my ($next, $self, $argument) = @_;

    if (defined $argument) {
        if ($argument !~ s{ \A \+ }{}xms) { # exclude explicitly assigned FQCN
            $argument = $self->canonize_format_class
                                ('Dumper', 'dumper_version', $argument);
        }
        return $self->$next($argument);
    }
    else {
        return $self->$next;
    }
};

around dump => sub {
    my ($next, $self, $dumper_alias) = @_;

    $self->dumper_class($dumper_alias)
        if defined $dumper_alias;

    # Caveat: $next calls Data::Dumper::Dumper
    return $self->dumper->dump;
};

sub convert_to {
    my ($self, $format, $version) = @_;

    $self->dumper_version($version)
        if defined $version;

    $self->dumper_class($format);

    return;

    # Fixme:
    # # Note: $some_lexicon->convert_to('Other::Format');
    # return unless defined wantarray;
    # 
    # # Note: $other_lexicon = $some_lexicon->convert_to('Other::Format');
    # return $self->clone;
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

Text::UTX::Feature::Dumper - Dumper feature for Text::UTX

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
