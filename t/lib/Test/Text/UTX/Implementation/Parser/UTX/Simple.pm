package Test::Text::UTX::Implementation::Parser::UTX::Simple;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Data::Util qw(neat);
use Test::Exception;
use Test::Moose;
use Test::More;


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Implementation::Parser::UTX::Simple::V0_90;
use Text::UTX::Implementation::Parser::UTX::Simple::V0_91;
use Text::UTX::Implementation::Parser::UTX::Simple::V0_92;
use Text::UTX::Implementation::Parser::UTX::Simple::V1_00;


# ****************************************************************
# superclass(es)
# ****************************************************************

use base qw(
    Test::Class
    Test::Text::UTX::Base
    Test::Text::UTX::Implementation::Parser::UTX::Simple::Utility
);


# ****************************************************************
# special method(s)
# ****************************************************************

sub startup : Test(startup => no_plan) {
    my $self = shift;

    foreach my $version ($self->versions) {
        my $class = $self->class($version);
        $self->test_meta_class($class);
        $self->test_roles($class);
        $self->test_attributes($class);
        $self->test_new($class, version => $version);
    }

    return;
}


# ****************************************************************
# general method(s)
# ****************************************************************

sub class {
    my ($self, $version) = @_;

    ( my $partly_qualified_version_name = 'V' . $version ) =~ tr{.}{_};

    return 'Text::UTX::Implementation::Parser::UTX::Simple::'
         . $partly_qualified_version_name;
}

sub roles {
    return qw(
        Text::UTX::Implementation::Parser::UTX::Simple
    );
}

sub attributes {
    return qw(
    );
}

sub versions {
    return qw(
        0.90
        0.91
        0.92
        1.00
    );
}

sub parser {
    my ($self, $version) = @_;

    return $self->class($version)->new(version => $version);
}


# ****************************************************************
# test method(s)
# ****************************************************************

sub test_parse : Tests {
    my $self = shift;

    foreach my $version ($self->versions ) {
        throws_ok {
            $self->class($version)->new;
        } qr{Could not construct the parser instance because version number must be specified},
        'Throws an exception : when version number does not specified';

        my $parser = $self->parser($version);

        is_deeply(
            $parser->parse(
                $self->parsing_arrayref(version => $version)
            ),
            $self->dump_utx_simple_as_arrayref(version => $version),
            qq{parse(version => "$version")},
        );

        # Caveat: Text::UTX::Feature::Parser convert Str to ArrayRef via
        #         $utx->loader->lines().
        #         But, Text::UTX::Implementation::Parser::* can receive
        #         ArrayRef only.
        # Todo: To implement test $utx->parser($str) and
        #       $utx->parser($arrayref).
        throws_ok {
            $parser->parse(
                $self->parsing_string(version => $version)
            );
        } qr{Could not parse lines because lines are not an array reference},
        'Throws an exception : when parse(Str)';

        throws_ok {
            $parser->parse(['Certain line without a comment sign']);
        } qr{Could not parse the header because comment sign does not exist},
        'Throws an exception : when comment sign does not exist';
    }

    return;
}

sub test__parse_format : Tests {
    my $self = shift;

    foreach my $version ($self->versions ) {
        my $parser = $self->parser($version);

        # Case: invalid specification
        foreach my $specification ('', 'UTX Simple', 'UTX S') {
            throws_ok {
                $parser->parse(
                    $self->parsing_arrayref(specification => $specification)
                );
            } qr{Could not parse a format because parsed specification name},
            sprintf(
                'Throws an exception : when invalid specification (%s)',
                    $specification,
            );
        }

        # Case: invalid version (imaginary string, empty string)
        ( my $partly_qualified_version_name = 'V' . $version ) =~ tr{.}{_};
        foreach my $invalid_version (
            $partly_qualified_version_name,
            q{},
        ) {
            throws_ok {
                $parser->parse(
                    $self->parsing_arrayref(version => $invalid_version)
                );
            } qr{Could not parse a format because parsed version number},
            sprintf(
                'Throws an exception : when invalid version (%s)',
                    $invalid_version,
            );
        }
    }

    return;
}

sub test__parse_alignment : Tests {
    my $self = shift;

    foreach my $version ($self->versions ) {
        my $parser = $self->parser($version);

        # Note: The parser does not treat upper/lower cases
        #       (and treats converting delimiter from '-' to '_').
        #       Build-in components (ex. Text::UTX::Component::Locale)
        #       treat cases instead.

        $self->sugared_test__parse_alignment(
            $parser,
            $version,
            'EN',
            { source => 'EN' }, # $self->structure_of_alignment('EN')
        );

        $self->sugared_test__parse_alignment(
            $parser,
            $version,
            'EN_us',
            { source => 'EN_us' },
        );

        $self->sugared_test__parse_alignment(
            $parser,
            $version,
            'EN-us',
            { source => 'EN-us' },
        );

        $self->sugared_test__parse_alignment(
            $parser,
            $version,
            'EN_us/ja-JP',
            { source => 'EN_us', target => 'ja-JP' },
        );

        throws_ok {
            $parser->parse(
                $self->parsing_arrayref(
                    version   => $version,
                    alignment => 'en/',
                )
            );
        } qr{Could not parse an alignment because the target language is the blank character},
        'en/';

        throws_ok {
            $parser->parse(
                $self->parsing_arrayref(
                    version   => $version,
                    alignment => '/en',
                )
            );
        } qr{Could not parse an alignment because the source language is the blank character},
        'en/';
    }

    return;
}

sub test__parse_miscellanies : Tests {
    my $self = shift;

    foreach my $version ($self->versions) {
        my $parser = $self->parser($version);

        $self->sugared_test__parse_miscellanies(
            $parser,
            $version,
            'foo:bar',
            [qw(foo bar)], # $self->structure_of_miscellanies($miscellanies)
        );

        $self->sugared_test__parse_miscellanies(
            $parser,
            $version,
            'foo:bar;',
            [qw(foo bar)],
        );

        $self->sugared_test__parse_miscellanies(
            $parser,
            $version,
            'foo:bar;baz:qux',
            [qw(foo bar baz qux)],
        );

        $self->sugared_test__parse_miscellanies(
            $parser,
            $version,
            'foo:bar;baz:qux;',
            [qw(foo bar baz qux)],
        );
    }

    return;
}

sub test__parse_columns : Tests {
    my $self = shift;

    foreach my $version ($self->versions) {
        my $parser = $self->parser($version);

        $self->sugared_test__parse_columns(
            $parser,
            $version,
            [qw(src    tgt    src:pos   )],
            [qw(source target source_pos)],
        );

        $self->sugared_test__parse_columns(
            $parser,
            $version,
            [qw(source target source_pos)],
            [qw(source target source_pos)],
        );

        $self->sugared_test__parse_columns(
            $parser,
            $version,
            [qw(src    tgt    src:pos    foo bar src:foo    tgt:foo   )],
            [qw(source target source_pos foo bar source_foo target_foo)],
        );
    }

    return;
}

sub test_parse_body : Tests {
    my $self = shift;

    foreach my $version ($self->versions) {
        my $parser = $self->parser($version);

        $self->sugared_test__parse_body(
            $parser,
            $version,
            [
                ("foo\tbar\t"),
            ],
            [
                { is_comment => q{}, columns => [qw(foo bar)] },
            ],
        );

        $self->sugared_test__parse_body(
            $parser,
            $version,
            [
                ("# foo\tbar\t"),
                ("baz\tqux\tquux"),
            ],
            [
                { is_comment => 1, columns => [qw(foo bar)] },
                { is_comment => q{}, columns => [qw(baz qux quux)] },
            ],
        );
    }

    return;
}


# ****************************************************************
# sugared test(s)
# ****************************************************************

sub sugared_test__parse_alignment {
    my ($self, $parser, $version, $input, $expected) = @_;

    is_deeply(
        $parser->parse(
            $self->parsing_arrayref(
                version   => $version,
                alignment => $input,
            )
        )->{alignment},
        $expected,
        sprintf(
            'Parsed alignment : when parse(alignment => %s), found %s',
                neat($input),
                neat($expected),
        ),
    );

    return;
}

sub sugared_test__parse_miscellanies {
    my ($self, $parser, $version, $input, $expected) = @_;

    is_deeply(
        $parser->parse(
            $self->parsing_arrayref(
                version      => $version,
                miscellanies => $input,
            )
        )->{miscellanies},
        $expected,
        sprintf(
            'Parsed miscellanies : when parse(miscellanies => %s), found %s',
                neat($input),
                neat($expected),
        ),
    );

    return;
}

sub sugared_test__parse_columns {
    my ($self, $parser, $version, $input, $expected) = @_;

    is_deeply(
        $parser->parse(
            $self->parsing_arrayref(
                version => $version,
                columns => $input,
            )
        )->{columns},
        $expected,
        sprintf(
            'Parsed columns : when parse(columns => %s), found %s',
                neat($input),
                neat($expected),
        ),
    );

    return;
}

sub sugared_test__parse_body {
    my ($self, $parser, $version, $input, $expected) = @_;

    is_deeply(
        $parser->parse(
            $self->parsing_arrayref(
                version => $version,
                entries => $input,
            )
        )->{entries},
        $expected,
        sprintf(
            'Parsed entries : when parse(entries => %s), found %s',
                neat($input),
                neat($expected),
        ),
    );
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

Test::Text::UTX::Implementation::Parser::UTX::Simple -

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
