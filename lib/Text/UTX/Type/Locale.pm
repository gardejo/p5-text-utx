package Text::UTX::Type::Locale;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use MooseX::Types (
    -declare => [qw(
        Locale
    )],
);
use MooseX::Types::Moose qw(
    Object
    Str
    ArrayRef
    HashRef
    ScalarRef
);


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

my $Locale_Class = 'Text::UTX::Component::Locale';


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# locale string (language + country)
# ----------------------------------------------------------------
subtype Locale,
    as Object,
        where {
            $_->isa($Locale_Class);
        };

coerce Locale,
    from ArrayRef,
        via {
            return $Locale_Class->new($_);
        },
    from HashRef,
        via {
            return $Locale_Class->new($_);
        },
    from ScalarRef,
        via {
            return $Locale_Class->new($_);
        },
    from Str,
        via {
            return $Locale_Class->new($_);
        };


# ****************************************************************
# compile-time process(es)
# ****************************************************************

# Note: __PACKAGE__ can not run consumed methods (ex. ensure_class_loaded)
Text::UTX::Utility::Class->ensure_class_loaded($Locale_Class);


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

Text::UTX::Type::Locale - Locale constraints and coercions for Moose

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

This module packages several
L<Moose::Util::TypeConstraints|Moose::Util::TypeConstraints> with coercions,
designed to work with the values of locale (language + country).

=head1 CONSTRAINTS AND COERCIONS

=over 4

=item C<Locale>

blah blah blah

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Language>

=item * L<Locale::Country>

=item * L<MooseX:Types::Locale::Language>

=item * L<MooseX:Types::Locale::Country>

=back

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at cpan dot org> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009-2010 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com/>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
