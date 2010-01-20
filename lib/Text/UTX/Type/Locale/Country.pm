package Text::UTX::Type::Locale::Country;


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
        Country
    )],
);
use MooseX::Types::Moose qw(
    Object
    Str
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

my $Country_Class = 'Text::UTX::Component::Locale::Country';


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# country (code, name)
# ----------------------------------------------------------------
subtype Country,
    as Object,
        where {
            $_->isa($Country_Class);
        };

coerce Country,
    from Str,
        via {
            return $Country_Class->new(
                  length $_ == 2 ? ( code => $_ )
                :                  ( name => $_ )
            );
        };


# ****************************************************************
# compile-time process(es)
# ****************************************************************

# Note: __PACKAGE__ can not run consumed methods (ex. ensure_class_loaded)
Text::UTX::Utility::Class->ensure_class_loaded($Country_Class);


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

Text::UTX::Type::Locale::Country - Country constraints and coercions for Moose

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

This module packages several
L<Moose::Util::TypeConstraints|Moose::Util::TypeConstraints> with coercions,
designed to work with the values of country.

=head1 CONSTRAINTS AND COERCIONS

=over 4

=item C<Country>

blah blah blah

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Country>

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
