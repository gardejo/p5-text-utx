package Text::UTX::Utility::Regexp;


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

use Moose::Role;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Regexp::Assemble;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean;


# ****************************************************************
# public method(s)
# ****************************************************************

# Todo: memoize it!
sub assemble_regexp_with_affixed_spaces {
    my ($self, $string) = @_;

    my $ra = Regexp::Assemble->new;
    # Caveat: use [ ](0x20) instead of \s, because \s contains \t(0x09)
    $ra->add(         $string         );
    $ra->add('[ ]*' . $string         );
    $ra->add(         $string . '[ ]*');
    $ra->add('[ ]*' . $string . '[ ]*');

    return $ra->re;
}

# Todo: memoize it!
sub assemble_regexp_from {
    my ($self, @strings) = @_;

    my $ra = Regexp::Assemble->new;
    foreach my $string (@strings) {
        $ra->add($string);
    }

    return $ra->re;
}

# Todo: memoize it!
sub escape_meta_characters_of_regexp {
    my ($self, $string) = @_;

    $string =~ s{
        (?<!
            \\
        )
        (?=
            [.]     # Todo: and more ...
        )
    }{\\}xmsg;

    return $string;
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

Text::UTX::Utility::Regexp - Regular expression related utility methods for Text::UTX

=head1 SYNOPSIS

    package Text::UTX;

    with qw(
        Text::UTX::Utility::Regexp
    );

=head1 DESCRIPTION

blah blah blah

=head1 AUTHOR

=over 4

=item MORIYA Masaki (a.k.a. Gardejo)

C<< <moriya at cpan dot org> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010 by MORIYA Masaki (a.k.a. Gardejo),
L<http://ttt.ermitejo.com/>.

This module is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlgpl> and L<perlartistic|perlartistic>.

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
