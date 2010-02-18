package Test::Text::UTX::Implementation::Loader::LWP::UserAgent;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use HTTP::Request::Common qw(GET);
use URI;
use Test::Exception;
use Test::More;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Implementation::Loader::LWP::UserAgent;


# ****************************************************************
# superclass(es)
# ****************************************************************

use base qw(
    Test::Class
    Test::Text::UTX::Base
    Test::Text::UTX::Implementation::Stream::LWP::UserAgent
);


# ****************************************************************
# special method(s)
# ****************************************************************

sub startup : Test(startup => no_plan) {
    my $self = shift;

    $self->test_meta_class;
    $self->test_roles;
    $self->test_attributes;
    $self->test_new;

    return;
}


# ****************************************************************
# general method(s)
# ****************************************************************

sub class {
    return 'Text::UTX::Implementation::Loader::LWP::UserAgent';
}

sub roles {
    return qw(
        Text::UTX::Implementation::Stream::LWP::UserAgent
        Text::UTX::Role::Loadable
        Text::UTX::Interface::Loader
    );
}

sub attributes {
    return qw(
    );
}

sub loader_class {
    return 'Text::UTX::Implementation::Loader::UserAgent';
}

# sub format_handler_class {
#     return 'Text::UTX::Implementation::Handler::Format::UTX::Simple';
# }


# ****************************************************************
# test method(s)
# ****************************************************************

sub test_stream : Tests {
    my $self = shift;

    $self->test_partly_qualified_class_name;
    $self->test_agent;

    return;
}

sub test_load : Tests {
    my $self = shift;

    my $loader = $self->class->new;

    SKIP: {
    skip 'blah blah blah';

    # Fixme: To test via Test::TCP
    my $instream = URI->new('t/rc/utx/simple/v1_00.utx');
    lives_ok {
        $loader->load($instream);
    } 'No exception to load';

    is(
        $loader->stream->canonical->as_string,
        $instream->canonical->as_string,
        'instream is the same as stream',
    );

    # diag explain ( GET $instream ); return;

    is_deeply(
        $loader->lines,
        [],
        'lines',
    );

    };

    return;
}

sub test_cloned_loader : Tests {
    my $self = shift;

    ok 1, 'foobar';

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

Test::Text::UTX::Implementation::Loader::LWP::UserAgent -

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
