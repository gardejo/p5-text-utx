package Test::Text::UTX::Base;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Data::Util qw(:check neat);
use Scalar::Util qw(refaddr);
use Test::Exception;
use Test::Moose;
use Test::More;


# ****************************************************************
# special method(s)
# ****************************************************************

=for comment

sub startup : Test(startup => no_plan) {
    my $self = shift;

    return;
}

sub setup : Test(setup) {
    my $self = shift;

    return;
}

sub teardown : Test(teardown) {
    my $self = shift;

    return;
}

sub shutdown : Test(shutdown) {
    my $self = shift;

    return;
}

=cut


# ****************************************************************
# utility method(s)
# ****************************************************************

sub test_accessor {
    my ($self, $instance, @remains) = @_;

    my ($writer, $reader, $test_cases);

    if (@remains == 2) {
        ($writer, $test_cases) = @remains;
    }
    elsif (@remains == 3) {
        ($writer, $reader, $test_cases) = @remains;
    }
    else {
        BAIL_OUT(
            sprintf(
                'Invalid attribute(s) for test_accessor(). '
              . 'from: (%s); instance: (%s); remains: (%s)',
                    ( caller(1) )[3],
                    neat($instance),
                    ( join '; ', @remains ),
            )
        );
    }

    foreach my $test_case (@$test_cases) {
        my ($input, $expected) = @$test_case;
        my $tester
            = defined $expected && is_value($expected)
                ? '_test_attribute_value'
            :
                  '_test_child_attribute';
        if (defined $reader) {
            $instance->$writer($input);
            $self->$tester
                ($writer, $input, [ $reader ],
                    $instance->$reader, $expected);
        }
        else {
            $self->$tester
                ($writer, $input, [ $writer ],
                    $instance->$writer($input), $expected);
        }
    }

    return;
}

sub test_accessor_exception {
    my ($self, $instance, $attribute, $inputs, $exception) = @_;

    foreach my $input (@$inputs) {
        throws_ok {
            $instance->$attribute($input);
        } $exception,
            sprintf(
                'Throws an exception : when %s(%s)',
                    $attribute,
                    neat($input),
            );
    }

    return;
}

sub test_cloning {
    my ($self, $origin, $kind,
        $lazy_attributes, $deep_attributes, $surface_attributes) = @_;

    map { $origin->$_ } @$lazy_attributes
        if defined $lazy_attributes;

    my $clone = $origin->clone;

    map { $clone->$_ } @$lazy_attributes
        if defined $lazy_attributes;

    is_deeply(
        $clone,
        $origin,
        sprintf (
            'Cloned %s has the same attribute values of original %s',
                $kind,
                $kind,
        ),
    );

    isnt(
        refaddr $clone,
        refaddr $origin,
        sprintf (
            'Cloned %s has the different reference address from original %s',
                $kind,
                $kind,
        ),
    );

    map {
        isnt(
            refaddr $clone->$_,
            refaddr $origin->$_,
            sprintf (
                'Cloned %s has the deeply cloned attribute (%s)',
                    $kind,
                    $_,
            ),
        );
    } @$deep_attributes
        if defined $deep_attributes;

    map {
        is(
            refaddr $clone->$_,
            refaddr $origin->$_,
            sprintf (
                'Cloned %s has the surfacely cloned attribute (%s)',
                    $kind,
                    $_,
            ),
        );
    } @$surface_attributes
        if defined $surface_attributes;

    return;
}

sub test_meta_class {
    my ($self, $class) = @_;

    meta_ok(
        $class || $self->class,
        sprintf(
            '%s class has a metaclass',
                $class || $self->class,
        ),
    );

    return;
}

sub test_roles {
    my ($self, $class) = @_;

    foreach my $role ($self->roles) {
        does_ok(
            $class || $self->class,
            $role,
            sprintf(
                '%s class consumes %s role',
                    $class || $self->class,
                    $role,
            ),
        );
    }

    return;
}

sub test_attributes {
    my ($self, $class) = @_;

    foreach my $attribute ($self->attributes) {
        has_attribute_ok(
            $class || $self->class,
            $attribute,
            sprintf(
                '%s class has %s attribute',
                    $class || $self->class,
                    $attribute,
            ),
        );
    }

    return;
}

sub test_new {
    my ($self, $class, @init_args) = @_;

    my $instance;

    $class ||= $self->class;

    lives_ok {
        $instance = $class->new(@init_args);
    } sprintf(
        '%s constructed without initial argument(s)',
            $class,
    );

    isa_ok(
        $instance,
        $class,
    );

    foreach my $attribute ($self->attributes) {
        my $predicator = 'has_' . $attribute;
        ok(
            ! $instance->$predicator,
            sprintf(
                '%s instance has not a %s',
                    $class,
                    $attribute,
            ),
        );
    }

    return;
}

sub _test_child_attribute {
    my ($self, $attribute, $input, $readers, $result, $expected) = @_;

    while (my ($reader, $value) = each %$expected) {
        if (is_hash_ref($value)) {
            $self->_test_child_attribute(
                $attribute,
                $input,
                [ @$readers, $reader ],
                $result->$reader,
                $value,
            );
        }
        else {
            $self->_test_attribute_value(
                $attribute,
                $input,
                [ @$readers, $reader ],
                $result->$reader,
                $value,
            );
        }
    }

    return;
}

sub _test_attribute_value {
    my ($self, $attribute, $input, $readers, $result, $expected) = @_;

    is(
        $result,
        $expected,
        sprintf(
            'Attribute value : when %s(%s), %s is %s',
                $attribute,
                neat($input),
                ( join '->', @$readers ),
                neat($expected),
        ),
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

Test::Text::UTX::Base -

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
