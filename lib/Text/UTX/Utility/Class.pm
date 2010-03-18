package Text::UTX::Utility::Class;


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

use Moose::Role;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# public method(s)
# ****************************************************************

sub ensure_class_loaded {
    my ($invocant, $class) = @_;

    return
        unless defined $class;

    Class::MOP::load_class($class)
        unless Class::MOP::is_class_loaded($class);

    return;
}

# Todo: memoize it!
sub version_for_class_name {
    my ($invocant, $version) = @_;

    ( my $version_for_class_name = $version ) =~ tr{.}{_};

    return 'V' . $version_for_class_name;
}


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

Text::UTX::Utility::Class - Class related utility methods for Text::UTX

=head1 SYNOPSIS

    package Text::UTX;

    with qw(
        Text::UTX::Utility::Class
    );

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

Copyright (c) 2010 by MORIYA Masaki, alias Gardejo

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
