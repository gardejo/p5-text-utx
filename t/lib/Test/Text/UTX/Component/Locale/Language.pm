package Test::Text::UTX::Component::Locale::Language;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Component::Locale::Language;


# ****************************************************************
# superclass(es)
# ****************************************************************

use base qw(
    Test::Class
    Test::Text::UTX::Base
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
    return 'Text::UTX::Component::Locale::Language';
}

sub roles {
    return qw(
        MooseX::Clone
    );
}

sub attributes {
    return qw(
        code
        name
    );
}


# ****************************************************************
# test method(s)
# ****************************************************************

sub test_code : Tests {
    my $self = shift;

    my $language = $self->class->new;

    $self->test_accessor(
        $language,
        'code',
        [
            [ 'en', 'en' ],
            [ 'En', 'en' ],
            [ 'eN', 'en' ],
            [ 'EN', 'en' ],
        ],
    );

    $self->test_accessor_exception(
        $language,
        'code',
        [
            undef,
            '',
            qw(
                **
            ),
            { code => 'en' },
            [ 'code', 'en' ],
        ],
        qr{Attribute \(code\) does not pass the type constraint},
    );

    return;
}

sub test_name : Tests {
    my $self = shift;

    my $language = $self->class->new;

    $self->test_accessor(
        $language,
        'name',
        [
            [ 'English', 'English' ],
            [ 'english', 'English' ],
            [ 'ENGLISH', 'English' ],
        ],
    );

    $self->test_accessor_exception(
        $language,
        'name',
        [
            undef,
            '',
            qw(
                ********
            ),
            { name => 'English' },
            [ 'name', 'English' ],
        ],
        qr{Attribute \(name\) does not pass the type constraint},
    );

    return;
}

sub test_lazy_name : Tests {
    my $self = shift;

    my $language = $self->class->new;

    $self->test_accessor(
        $language,
        'code', 'name',
        [
            [ 'en', 'English'  ],
            [ 'ja', 'Japanese' ],
        ],
    );

    return;
}

sub test_lazy_code : Tests {
    my $self = shift;

    my $language = $self->class->new;

    $self->test_accessor(
        $language,
        'name', 'code',
        [
            [ 'English',  'en' ],
            [ 'Japanese', 'ja' ],
        ],
    );

    return;
}

sub test_cloned_language : Tests {
    my $self = shift;

    my $language = $self->class->new(name => 'English');
    $self->test_cloning(
        $language,
        'language',
        [qw(name code)],
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

Test::Text::UTX::Component::Locale::Language -

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
