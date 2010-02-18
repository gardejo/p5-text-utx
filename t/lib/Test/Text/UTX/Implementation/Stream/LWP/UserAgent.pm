package Test::Text::UTX::Implementation::Stream::LWP::UserAgent;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::More;


# ****************************************************************
# general method(s)
# ****************************************************************

sub stream_handler_class {
    return 'Text::UTX::Implementation::Handler::Stream::LWP::UserAgent';
}


# ****************************************************************
# test method(s)
# ****************************************************************

sub test_partly_qualified_class_name {
    my $self = shift;

    isa_ok(
        $self->class->new->partly_qualified_class_name,
        'LWP::UserAgent',
    );

    return;
}

sub test_agent {
    my $self = shift;

    isa_ok(
        $self->class->new->agent,
        'LWP::UserAgent',
    );

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

=head1 NAME

Test::Text::UTX::Implementation::Stream::LWP::UserAgent -

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

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlapi> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
