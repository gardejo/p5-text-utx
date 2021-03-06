package Text::UTX::Type::Alignment;


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
    Alignment
)];
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

my $Alignment_Class = 'Text::UTX::Component::Alignment';


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# alignment string (source + target)
# ----------------------------------------------------------------
subtype Alignment,
    as Object,
        where {
            $_->isa($Alignment_Class) && defined $_->source;
        };

coerce Alignment,
    from ArrayRef,
        via {
            return $Alignment_Class->new(
                source => $_->[0],
                ( defined $_->[1] ? (target => $_->[1]) : () ),
            );
        },
    from HashRef,
        via {
            return $Alignment_Class->new($_);
        },
    from ScalarRef,
        via {
            return $Alignment_Class->new(alignment => $$_);
        },
    from Str,
        via {
            return $Alignment_Class->new(alignment => $_);
        };


# ****************************************************************
# compile-time process(es)
# ****************************************************************

# Note: __PACKAGE__ cannot run consumed methods (ex. ensure_class_loaded()).
Text::UTX::Utility::Class->ensure_class_loaded($Alignment_Class);


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

Text::UTX::Type::Alignment - Alignment constraints and coercions for Moose

=head1 SYNOPSIS

    # yada yada yada

=head1 DESCRIPTION

This module packages several
L<Moose::Util::TypeConstraints|Moose::Util::TypeConstraints> with coercions,
designed to work with the values of alignment (source + target).

=head1 CONSTRAINTS AND COERCIONS

=over 4

=item C<Alignment>

blah blah blah

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Language|Locale::Language>

=item * L<Locale::Country|Locale::Country>

=item * L<MooseX:Types::Locale::Language|MooseX:Types::Locale::Language>

=item * L<MooseX:Types::Locale::Country|MooseX:Types::Locale::Country>

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
