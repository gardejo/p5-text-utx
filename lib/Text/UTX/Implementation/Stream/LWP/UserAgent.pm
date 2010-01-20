package Text::UTX::Implementation::Stream::LWP::UserAgent;


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
use MooseX::Types::URI qw(Uri);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use LWP::UserAgent;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# attribute(s)
# ****************************************************************

has 'agent' => (
    is          => 'rw',
    isa         => 'LWP::UserAgent',
    lazy_build  => 1,
);


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Role::StreamLike
    Text::UTX::Role::HasLines
);


# ****************************************************************
# inherited attribute(s)
# ****************************************************************

has '+stream' => (
    # required    => 1,
    isa         => Uri,
    coerce      => 1,
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_partly_qualified_class_name {
    return 'LWP::UserAgent';
}

sub _build_agent {
    my $self = shift;

    return LWP::UserAgent->new;
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

Text::UTX::Implementation::Stream::LWP::UserAgent - 

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

blah blah blah

=head2 Using proxy

blah blah blah

See L<LWP::UserAgent|LWP::UserAgent>.

For exmample:

    use LWP::UserAgent;
    use Text::UTX::Implementation::Loader::LWP::UserAgent;

    my $agent = LWP::UserAgent->new;
    $agent->proxy( [qw(http ftp)], 'http://proxy.yourcompany.example:8080/' );
    # if you want to pass an authentication...
    # $agent->credentials(
    #     'auth.yourcompany.example:80',
    #     'username',
    #     'password',
    # );
    Text::UTX::Implementation::Loader::LWP::UserAgent->new(
        agent => $agent,
    );

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
