package Text::UTX::Type::Locale::Language;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer cannot detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use MooseX::Types -declare => [qw(
    Language
)];
use MooseX::Types::Moose qw(
    Maybe
    Object
    Str
    HashRef
    ScalarRef
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Carp qw(confess);


# ****************************************************************
# internal dependency(-ies)
# ****************************************************************

use Text::UTX::Utility::Class;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# class variable(s)
# ****************************************************************

my $Language_Class = 'Text::UTX::Component::Locale::Language';


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# language (code, name)
# ----------------------------------------------------------------
subtype Language,
    as Maybe[Object],
        where {
            ! defined $_ || $_->isa($Language_Class);
        };

coerce Language,
    from HashRef,
        via {
            confess sprintf '%s allows a hash reference with a single key '
                          . 'for constructor',
                        $Language_Class
                if keys %$_ > 1;
            return $Language_Class->new($_);
        },
    from ScalarRef,
        via {
            return $Language_Class->new(
                  length $$_ == 2 ? ( code => $$_ )
                :                   ( name => $$_ )
            );
        },
    from Str,
        via {
            return $Language_Class->new(
                  length $_ == 2 ? ( code => $_ )
                :                  ( name => $_ )
            );
        };


# ****************************************************************
# compile-time process(es)
# ****************************************************************

# Note: __PACKAGE__ cannot run consumed methods (ex. ensure_class_loaded()).
Text::UTX::Utility::Class->ensure_class_loaded($Language_Class);


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

Text::UTX::Type::Locale::Language - Language constraints and coercions for Moose

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

This module packages several
L<Moose::Util::TypeConstraints|Moose::Util::TypeConstraints> with coercions,
designed to work with the values of language.

=head1 CONSTRAINTS AND COERCIONS

=over 4

=item C<Language>

blah blah blah

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Language|Locale::Language>

=item * L<MooseX:Types::Locale::Language|MooseX:Types::Locale::Language>

=back

=head1 AUTHOR

=over 4

=item MORIYA Masaki, alias Gardejo

C<< <moriya at cpan dot org> >>,
L<http://gardejo.org/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 by MORIYA Masaki, alias Gardejo

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
