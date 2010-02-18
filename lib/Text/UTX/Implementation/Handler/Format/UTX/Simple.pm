package Text::UTX::Implementation::Handler::Format::UTX::Simple;


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

use Moose;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use List::MoreUtils qw(apply);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Implementation::Format::UTX::Simple
    Text::UTX::Role::Handlable
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_aliases {
    my @aliases = qw(UTX-S UTX-Simple);
    @aliases = ( @aliases, apply { $_ =~ s{-}{ }xmsg } @aliases );
    return \@aliases;
}



# ****************************************************************
# public method(s)
# ****************************************************************

around canonize => sub {
    my ($next, $self, $role_kind, $framework, $alias) = @_;

    my $concrete_class = $self->$next($role_kind, $framework, $alias);

    if ($role_kind eq 'Parser') {
        $self->_guess_version_for_parser
                    ( $framework, $framework->loader->get_line(0) );
    }
    elsif ($role_kind eq 'Dumper') {
        $self->_guess_version_for_dumper( $framework );
    }

    return $concrete_class;
};

sub guess {
    my ($self, $role_kind, $framework, $stream) = @_;

    return
        if defined $stream && $stream !~ $self->extension_pattern;

    if ($role_kind eq 'Parser') {
        return $self->_guess_for_parser($role_kind, $framework, $stream);
    }
    elsif ($role_kind eq 'Dumper') {
        return $self->_guess_for_dumper($role_kind, $framework, $stream);
    }

    return;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _guess_for_parser {
    my ($self, $role_kind, $framework, $instream) = @_;

    # my $first_line = $framework->get_line(0);
    my $first_line = $framework->loader->get_line(0);

    return
        if $first_line !~ m{ \A \# UTX-S }xms;

    $self->_guess_version_for_parser($framework, $first_line);

    return $self->fully_qualified_class_name($role_kind);
}

sub _guess_for_dumper {
    my ($self, $role_kind, $framework, $outstream) = @_;

    $self->_guess_version_for_dumper($framework);

    return $self->fully_qualified_class_name($role_kind);
}

sub _guess_version_for_parser {
    my ($self, $framework, $first_line) = @_;

    my $version;

    if ($framework->has_parser_version) {
        $version = $framework->parser_version;
    }
    else {
        $first_line =~ m{
            \A
            \#    \s*
            UTX-S \s*
            (
                [\d\.]+
            )
        }xms;
        $version = defined $1 ? $1 : $self->latest_version;
    }

    $self->version( $version );

    return;
}

sub _guess_version_for_dumper {
    my ($self, $framework) = @_;

    my $version;

    if ($framework->has_dumper_version) {
        $version = $framework->dumper_version;
    }
    else {
        $version = $framework->has_instream && $framework->parser_version
            ? $framework->parser_version
            : $self->latest_version;
    }

    $self->version($version);

    return;
}


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


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

Text::UTX::Implementation::Handler::Format::UTX::Simple - 

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
