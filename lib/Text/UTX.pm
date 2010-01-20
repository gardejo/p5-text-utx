package Text::UTX;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;


# ****************************************************************
# perl dependency
# ****************************************************************

use 5.008_001;


# ****************************************************************
# MOP dependency(-ies)
# ****************************************************************

use Moose;


# ****************************************************************
# namespace cleaner
# ****************************************************************

use namespace::clean -except => [qw(meta)];


# ****************************************************************
# class variable(s)
# ****************************************************************

our $VERSION = '0.00';


# ****************************************************************
# consuming role(s)
# ****************************************************************

# with qw(
#     MooseX::Clone
# );

with qw(
    Text::UTX::Role::LexiconLike
);

# feature(s)
# Note: all consuming roles have a strategy (of the Strategy pattern)
with qw(
    Text::UTX::Feature::Dumper
    Text::UTX::Feature::Handler
    Text::UTX::Feature::Loader
    Text::UTX::Feature::Parser
    Text::UTX::Feature::Saver
);


# ****************************************************************
# compile-time process(es)
# ****************************************************************

__PACKAGE__->meta->make_immutable;


# ****************************************************************
# return true
# ****************************************************************

__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Text::UTX - Abstract layer (parser/writer) for UTX Simple and other lexicon formats

=head1 SYNOPSIS

    use Text::UTX;

    # load local UTX dictionary
    my $utx_en_eo = Text::UTX->new;
    $utx_en_eo->load('/home/johndoe/dictionary/utx/en_eo.utx');     # read

    # load network UTX dictionary
    my $utx_eo_en = Text::UTX->new;
    $utx_eo_en->load('http://dictionary.example/utx/eo_en.utx');    # download

    # explicitly define loader class
    my $strictry_utx = Text::UTX->new;
    $utx->load('/home/johndoe/dictionary/unknown.txt' => 'UTX-S');

    # same as above
    $strictry_utx = Text::UTX->new;
    $strictry_utx->instream('/home/johndoe/dictionary/unknown.txt');
    $strictry_utx->parser_class('UTX-S');
    $strictry_utx->load;

    # same as above
    # implement your Text::UTX::Implementation::Handler::Stream::TxtAsUtx

    # load local Eijiro dictionary
    # (caveat: required Text::UTX::Implementation::Eijiro)
    $eijiro_en_ja = Text::UTX->new;
    $eijiro_en_ja->load('/home/johndoe/dictionary/eijiro/EIJIRO76.TXT');

    # save to the same file
    $utx_en_eo->save;

    # save to an other file
    $utx_en_eo->save('/home/alice/dictionary/utx/en_eo.utx');

    # convert from UTX into Eijiro
    my $eijiro_en_eo = $utx_en_eo->convert_to('Eijiro');            # clone
    $eijiro->save('/home/johndoe/dictionary/eijiro/en_eo.txt');     # write
    $eijiro->save('http://dictionary.example/eijiro/eo_en.utx');    # upload

    # same as above
    $utx_en_eo->convert_to('Eijiro');                               # no clone
    $utx_en_eo->save('/home/johndoe/dictionary/eijiro/en_eo.txt');  # write
    $utx_en_eo->save('http://dictionary.example/eijiro/eo_en.utx'); # upload

=head1 VERSION

0.00

=head1 DESCRIPTION

This framework provides you with an abstract layer for an user's dictionary(lexicon) of a machine translation software.

blah blah blah

=head1 ACKNOWLEDGEMENTS

There are many people who helped bring this module about.
I extend my gratitude to:

=over 4

=item Sharing/Standardization Working Group, MT Research Committee, AAMT, L<http://www.aamt.info/english/utx/>

For many advice to release this module.
Additionally, 

=item Francis Bond, L<http://www3.ntu.edu.sg/home/fcbond/>

For many information and advice of the UTX-Simple specification.
Additionally, he adjusted affairs at AAMT to release this module.

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

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl|perlapi> and L<perlartistic|perlartistic>.

=cut
