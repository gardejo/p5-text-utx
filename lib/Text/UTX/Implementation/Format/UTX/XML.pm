package Text::UTX::Implementation::Format::UTX::XML;


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

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# consuming role(s)
# ****************************************************************

with qw(
    Text::UTX::Role::FormatLike
);


# ****************************************************************
# builder(s)
# ****************************************************************

sub _build_partly_qualified_class_name {
    return 'UTX::XML';
}

sub _build_specification {
    return 'UTX XML';
}

sub _build_latest_version {
    return $_[0]->_not_released;
}

sub _build_extension {
    return '.xml';
}

sub _build_uri {
    return $_[0]->_not_released;
}


# ****************************************************************
# protected/private method(s)
# ****************************************************************

sub _not_released {
    confess 'Could not run several methods because '
          . 'UTX XML specification was not released yet';
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

Text::UTX::Implementation::Format::UTX::XML - 

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

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
