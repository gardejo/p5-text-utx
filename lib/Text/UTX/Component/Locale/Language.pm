package Text::UTX::Component::Locale::Language;


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

use Moose;
use MooseX::Types::Locale::Language qw(LanguageCode LanguageName);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Locale::Language qw(code2language language2code);


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'code' => (
    is          => 'rw',
    isa         => LanguageCode,
    coerce      => 1,
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_name;
    },
);

has 'name' => (
    is          => 'rw',
    isa         => LanguageName,
    coerce      => 1,
    lazy_build  => 1,
    trigger     => sub {
        $_[0]->clear_code;
    },
);


# ****************************************************************
# hook(s) on construction
# ****************************************************************

around BUILDARGS => sub {
    my ($next, $class, @init_args) = @_;

    if (scalar @init_args == 1) {
        return $class->$next(
              length $init_args[0] == 2 ? ( code => $init_args[0] )
            :                             ( name => $init_args[0] )
        );
    }
    else {
        return $class->$next(@init_args);
    }
};


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_code {
    my $self = shift;

    return language2code $self->name;
}

sub _build_name {
    my $self = shift;

    return code2language $self->code;
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

Text::UTX::Component::Locale::Language - 

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
