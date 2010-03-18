package Test::Text::UTX::Component::Locale::Country;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Component::Locale::Country;


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
    return 'Text::UTX::Component::Locale::Country';
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

    my $country = $self->class->new;

    $self->test_accessor(
        $country,
        'code',
        [
            [ 'us', 'US' ],
            [ 'Us', 'US' ],
            [ 'uS', 'US' ],
            [ 'US', 'US' ],
        ],
    );

    $self->test_accessor_exception(
        $country,
        'code',
        [
            undef,
            '',
            qw(
                **
            ),
            { code => 'US' },
            [ 'code', 'US' ],
        ],
        qr{Attribute \(code\) does not pass the type constraint},
    );

    return;
}

sub test_name : Tests {
    my $self = shift;

    my $country = $self->class->new;

    $self->test_accessor(
        $country,
        'name',
        [
            [ 'United States', 'United States' ],
            [ 'united states', 'United States' ],
            [ 'UNITED STATES', 'United States' ],
        ],
    );

    $self->test_accessor_exception(
        $country,
        'name',
        [
            undef,
            '',
            qw(
                ********
            ),
            { name => 'United States' },
            [ 'name', 'United States' ],
        ],
        qr{Attribute \(name\) does not pass the type constraint},
    );

    return;
}

sub test_lazy_name : Tests {
    my $self = shift;

    my $country = $self->class->new;

    $self->test_accessor(
        $country,
        'code' => 'name',
        [
            [ 'US', 'United States' ],
            [ 'JP', 'Japan' ],
        ],
    );

    return;
}

sub test_lazy_code : Tests {
    my $self = shift;

    my $country = $self->class->new;

    $self->test_accessor(
        $country,
        'name' => 'code',
        [
            [ 'United States', 'US' ],
            [ 'Japan',         'JP' ],
        ],
    );

    return;
}

sub test_cloned_country : Tests {
    my $self = shift;

    my $country = $self->class->new(name => 'United States');
    $self->test_cloning(
        $country,
        'country',
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

Test::Text::UTX::Component::Locale::Country -

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
