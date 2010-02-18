package Test::Text::UTX::Implementation::Loader::Path::Class;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Path::Class qw(file);
use Test::Exception;
use Test::More;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Implementation::Loader::Path::Class;


# ****************************************************************
# superclass(es)
# ****************************************************************

use base qw(
    Test::Class
    Test::Text::UTX::Base
    Test::Text::UTX::Implementation::Stream::Path::Class
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
    return 'Text::UTX::Implementation::Loader::Path::Class';
}

sub roles {
    return qw(
        Text::UTX::Implementation::Stream::Path::Class
        Text::UTX::Role::Loadable
        Text::UTX::Interface::Loader
    );
}

sub attributes {
    return qw(
    );
}

sub stream_handler_class {
    return 'Text::UTX::Implementation::Handler::Stream::Path::Class';
}

sub loader_class {
    return 'Text::UTX::Implementation::Loader::Path::Class';
}

sub versions {
    return qw(
        0.90
        0.91
        0.92
        1.00
    );
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

    return;
}

sub test_load : Tests {
    my $self = shift;

    my $loader = $self->class->new;

    my $instream = file('t/rc/utx/simple/v1_00.utx');
    lives_ok {
        $loader->load($instream->stringify);
    } 'No exceptions to load';

    is(
        $loader->stream->stringify,
        $instream->stringify,
        'instream is the same as stream',
    );

    is_deeply(
        $loader->lines,
        [ $instream->slurp(chomp => 1) ],
        'lines',
    );

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

Test::Text::UTX::Implementation::Loader::Path::Class -

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
