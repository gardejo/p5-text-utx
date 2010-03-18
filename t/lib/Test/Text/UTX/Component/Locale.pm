package Test::Text::UTX::Component::Locale;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Component::Locale;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Test::Exception;
use Test::More;


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
    return 'Text::UTX::Component::Locale';
}

sub roles {
    return qw(
    );
}

sub attributes {
    return qw(
        locale
        language
        country
        delimiter
    );
}


# ****************************************************************
# test method(s)
# ****************************************************************

sub test_delimiter : Tests {
    my $self = shift;

    my $locale = $self->class->new;
    is(
        $locale->delimiter,
        '_',
    );

    throws_ok {
        $self->class->new(delimiter => '_');
    } qr{Found unknown attribute\(s\)},
        'delimiter => ( init_arg => undef )';

    $self->test_accessor_exception(
        $locale,
        'delimiter',
        [
            '_',
        ],
        qr{Cannot assign a value to a read-only accessor},
    );

    return;
}

sub test_language : Tests {
    my $self = shift;

    my $locale = $self->class->new;

    $self->test_accessor(
        $locale,
        'language',
        [
            [ undef, undef ],
            [ {}, undef ],
            [ 'en',
                { code => 'en', name => 'English' } ],
            [ { code => 'en' },
                { code => 'en', name => 'English' } ],
            [ 'English',
                { code => 'en', name => 'English' } ],
            [ { name => 'English' },
                { code => 'en', name => 'English' } ],
        ],
    );

    $self->test_accessor_exception(
        $locale,
        'language',
        [
            '**',
            { code => '********' },
        ],
        qr{Attribute \(code\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'language',
        [
            '',
            '********',
            { name => '********' },
        ],
        qr{Attribute \(name\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'language',
        [
            { code => '**', name => '********' },
        ],
        qr{allows a hash reference with a single key for constructor},
    );

    $self->test_accessor_exception(
        $locale,
        'language',
        [
            [],
            [ 'foo',  'bar'     ],
            [ 'name', 'English' ],
        ],
        qr{Attribute \(language\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'language',
        [
            { foo => 'bar' },
        ],
        qr{Found unknown attribute\(s\)},
    );

    return;
}

sub test_country : Tests {
    my $self = shift;

    my $locale = $self->class->new;

    $self->test_accessor(
        $locale,
        'country',
        [
            [ undef, undef ],
            [ {}, undef ],
            [ 'US',
                { code => 'US', name => 'United States' } ],
            [ { code => 'US' },
                { code => 'US', name => 'United States' } ],
            [ 'United States',
                { code => 'US', name => 'United States' } ],
            [ { name => 'United States' },
                { code => 'US', name => 'United States' } ],
        ],
    );

    $self->test_accessor_exception(
        $locale,
        'country',
        [
            '**',
        ],
        qr{Attribute \(code\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'country',
        [
            '',
            '********',
        ],
        qr{Attribute \(name\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'country',
        [
            { code => '**', name => '********' },
        ],
        qr{allows a hash reference with a single key for constructor},
    );

    $self->test_accessor_exception(
        $locale,
        'country',
        [
            [],
            [ 'foo',  'bar'     ],
            [ 'name', 'English' ],
        ],
        qr{Attribute \(country\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'country',
        [
            { foo => 'bar' },
        ],
        qr{Found unknown attribute\(s\)},
    );

    return;
}

sub test_locale : Tests {
    my $self = shift;

    my $locale = $self->class->new;

    $self->test_accessor(
        $locale,
        'locale',
        [
            [ undef,   undef   ],
            [ 'en',    'en'    ],
            [ 'en_US', 'en_US' ],
            [ 'en-US', 'en-US' ],
        ],
    );

    $self->test_accessor_exception(
        $locale,
        'locale',
        [
            '',
            'en_',
            'en_**',
            '_US',
            '**_US',
            '**',
            '********',
        ],
        qr{Attribute \(locale\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $locale,
        'locale',
        [
            [],
            [ 'en', 'US' ],
            {},
            { 'en' => 'US' },
            sub { return 'en_US' },
        ],
        qr{Attribute \(locale\) does not pass the type constraint},
    );

    return;
}

sub test_lazy_language : Tests {
    my $self = shift;

    my $locale = $self->class->new;

    $self->test_accessor(
        $locale,
        'locale' => 'language',
        [
            [ 'en',
                { code => 'en', name => 'English' } ],
            [ 'en_US',
                { code => 'en', name => 'English' } ],
        ],
    );

    return;
}

sub test_lazy_country : Tests {
    my $self = shift;

    my $locale = $self->class->new;

    $self->test_accessor(
        $locale,
        'locale' => 'country',
        [
            [ 'en',
                undef ],
            [ 'en_US',
                { code => 'US', name => 'United States' } ],
        ],
    );

    return;
}

sub test_lazy_locale : Tests {
    my $self = shift;

    my $locale;

    # (default) + language
    $locale = $self->class->new;
    $self->test_accessor(
        $locale,
        # { 'language' => 'locale' },
        'language' => 'locale',
        [
            [ 'en', 'en' ],
        ],
    );

    # country + language
    $locale = $self->class->new(country => 'US');
    $self->test_accessor(
        $locale,
        'language' => 'locale',
        [
            [ 'en', 'en_US' ],
        ],
    );

    # language + country
    $locale = $self->class->new(language => 'en');
    $self->test_accessor(
        $locale,
        'country' => 'locale',
        [
            [ 'US', 'en_US' ],
        ],
    );

    # (default) + country
    $locale = $self->class->new;
    $self->test_accessor(
        $locale,
        'country' => 'locale',
        [
            [ 'US', undef ],
        ],
    );

    return;
}

sub test_cloned_locale : Tests {
    my $self = shift;

    my $locale = $self->class->new(language => 'en', country => 'US');
    $self->test_cloning(
        $locale,
        'locale',
        [qw(locale language country)],
        [qw(language country)],
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

Test::Text::UTX::Component::Locale -

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

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlapi> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
