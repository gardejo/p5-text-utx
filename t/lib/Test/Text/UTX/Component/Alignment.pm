package Test::Text::UTX::Component::Alignment;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Component::Alignment;


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
    return 'Text::UTX::Component::Alignment';
}

sub roles {
    return qw(
    );
}

sub attributes {
    return qw(
        alignment
        source
        target
        delimiter
    );
}


# ****************************************************************
# test method(s)
# ****************************************************************

sub test_delimiter : Tests {
    my $self = shift;

    my $alignment = $self->class->new;
    my $expected_delimiter = '/';
    is(
        $alignment->delimiter,
        $expected_delimiter,
        sprintf(
            "Attribute value : delimiter is '%s'",
            $expected_delimiter,
        ),
    );

    throws_ok {
        $self->class->new(delimiter => '/');
    } qr{Found unknown attribute\(s\)},
        'delimiter => ( init_arg => undef )';

    $self->test_accessor_exception(
        $alignment,
        'delimiter',
        [
            '/',
        ],
        qr{Cannot assign a value to a read-only accessor},
    );

    return;
}

sub test_source : Tests {
    my $self = shift;

    my $alignment = $self->class->new;

    $self->test_accessor(
        $alignment,
        'source',
        [
            [ undef, undef ],
            [ {}, undef ],
            [ [], undef ],
            [ 'en' => {
                language => { name => 'English' },
            } ],
            [ [ 'en' ] => {
                language => { name => 'English' },
            } ],
            [ { language => 'en' } => {
                language => { name => 'English' },
            } ],
            [ 'en_US' => {
                language => { name => 'English'       },
                country  => { name => 'United States' },
            } ],
            [ [ 'en', 'US' ] => {
                language => { name => 'English'       },
                country  => { name => 'United States' },
            } ],
            [ { language => 'en', country => 'US' } => {
                language => { name => 'English'       },
                country  => { name => 'United States' },
            } ],
        ],
    );

    $self->test_accessor_exception(
        $alignment,
        'source',
        [
            { language => '**' },
            { country  => '**' },
        ],
        qr{Attribute \(code\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $alignment,
        'source',
        [
            { language => '********' },
            { country  => '********' },
        ],
        qr{Attribute \(name\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $alignment,
        'source',
        [
            '',
            '**',
            '********',
        ],
        qr{Attribute \(locale\) does not pass the type constraint},
    );

    return;
}

sub test_target : Tests {
    my $self = shift;

    my $alignment = $self->class->new;

    $self->test_accessor(
        $alignment,
        'target',
        [
            [ undef, undef ],
            [ {}, undef ],
            [ [], undef ],
            [ 'en' => {
                language => { name => 'English' },
            } ],
            [ [ 'en' ] => {
                language => { name => 'English' },
            } ],
            [ { language => 'en' } => {
                language => { name => 'English' },
            } ],
            [ 'en_US' => {
                language => { name => 'English'       },
                country  => { name => 'United States' },
            } ],
            [ [ 'en', 'US' ] => {
                language => { name => 'English'       },
                country  => { name => 'United States' },
            } ],
            [ { language => 'en', country => 'US' } => {
                language => { name => 'English'       },
                country  => { name => 'United States' },
            } ],
        ],
    );

    $self->test_accessor_exception(
        $alignment,
        'target',
        [
            { language => '**' },
            { country  => '**' },
        ],
        qr{Attribute \(code\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $alignment,
        'target',
        [
            { language => '********' },
            { country  => '********' },
        ],
        qr{Attribute \(name\) does not pass the type constraint},
    );

    $self->test_accessor_exception(
        $alignment,
        'target',
        [
            '',
            '**',
            '********',
        ],
        qr{Attribute \(locale\) does not pass the type constraint},
    );

    return;
}

sub test_alignment : Tests {
    my $self = shift;

    my $alignment = $self->class->new;

    $self->test_accessor_exception(
        $alignment,
        'alignment',
        [
            undef,
            '',
            '**',
            'en',
            '**/**',
            'en/ja',
            'en_US/ja_JP',
            [],
            [qw(en ja)],
            {},
            { source => 'en', target => 'ja' },
            sub { return 'en_US/ja_JP' },
        ],
        qr{Cannot assign a value to a read-only accessor},
    );
}

sub test_lazy_alignment : Tests {
    my $self = shift;

    my $alignment;

    # (default) + source
    $alignment = $self->class->new;
    $self->test_accessor(
        $alignment,
        'source' => 'alignment',
        [
            [ 'en',    'en'    ],
            [ 'en_US', 'en_US' ],
        ],
    );

    # target + source
    $alignment = $self->class->new(target => 'ja');
    $self->test_accessor(
        $alignment,
        'source' => 'alignment',
        [
            [ 'en',    'en/ja'    ],
            [ 'en_US', 'en_US/ja' ],
        ],
    );

    # source + target
    $alignment = $self->class->new(source => 'ja');
    $self->test_accessor(
        $alignment,
        'target' => 'alignment',
        [
            [ 'en',    'ja/en'    ],
            [ 'en_US', 'ja/en_US' ],
        ],
    );

    # (default) + target
    $alignment = $self->class->new;
    $self->test_accessor(
        $alignment,
        'target' => 'alignment',
        [
            [ 'en',    undef ],
            [ 'en_US', undef ],
        ],
    );

    return;
}

sub test_cloned_alignment : Tests {
    my $self = shift;

    my $alignment = $self->class->new(source => 'en_US', target => 'ja_JP');
    $self->test_cloning(
        $alignment,
        'alignment',
        [qw(alignment source target)],
        [qw(source target)],
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

Test::Text::UTX::Component::Alignment -

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
