package Text::UTX;


# ****************************************************************
# pragma(s)
# ****************************************************************

# Moose turns strict/warnings pragmas on,
# however, kwalitee scorer cannot detect such mechanism.
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
use MooseX::StrictConstructor;


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

# Note: All consuming roles have a strategy (of the Strategy pattern).
with qw(
    Text::UTX::Feature::Handler
    Text::UTX::Feature::Loader
    Text::UTX::Feature::Parser
    Text::UTX::Feature::Dumper
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

=head1 VERSION

This document describes C<Text::UTX> version B<0.00>.

=head1 SYNOPSIS

    use Text::UTX;

    my $utx = Text::UTX->new;

    # load and parse an UTX dictionary
    $utx->load('/home/alice/utx/en_eo.utx');        # read local file
    $utx->load('http://dict.example/eo_en.utx');    # download via Internet
    $utx->load('/home/bob/foo.txt' => 'UTX-S');     # explicit loader class

    # same as above
    $utx = Text::UTX->new;
    $utx->instream('/home/dave/bar.txt');
    $utx->parser_class('UTX-S');
    $utx->load;
    # or, implement Text::UTX::Implementation::Handler::Stream::TxtAsUtx

    # load and parse an Eijiro (http://www.eijiro.jp/) dictionary
    # (caveat: required Text::UTX::Implementation::Format::Eijiro series)
    $utx->load('/home/ellen/eijiro/EIJIRO76.TXT');

    # parse a string (Text::UTX can also an array reference)
    $utx->parse(
        "#UTX-S 1.00; en/eo; 2010-01-01T00:00:00Z\n"
      . "#src\ttgt\tsrc:pos\n"
      . "hellow\tsaluton\t\n"
      . "world\tmondo\t\n"
    );

    # dump as strings...
    my $str_utx_simple_1_00 = $utx->dump;           # as UTX Simple 1.00
    my $str_eijiro          = $utx->dump('Eijiro'); # as Eijiro

    # dump and save...
    $utx->save;                                     # to the same file
    $utx->save('/home/frank/utx/en_eo.utx');        # to an other file

    # convert from UTX format into Eijiro
    my $eijiro = $utx->convert_to('Eijiro');                # clone
    $eijiro->save('/home/isaac/eijiro/en_eo.txt');          # write
    $eijiro->save('http://dict.example/eijiro/eo_en.utx');  # upload

    # same as above
    $utx->convert_to('Eijiro');                             # no clone
    $utx->save('/home/justin/eijiro/en_eo.txt');            # write
    $utx->save('http://dict.example/eijiro/eo_en.utx');     # upload

=head1 DESCRIPTION

This framework provides you with an abstract layer for an user's dictionary
of a machine translation software.

blah blah blah


=head2 Figure 2. The Architecture of Text::UTX

    * Container
      Text::UTX

    * Features
        - Text::UTX::Loader
        - Text::UTX::Parser
        - Text::UTX::Dumper
        - Text::UTX::Saver

    * Implementations/Formats
        - Text::UTX::Implementation::Format::UTX::Simple::*
            - Text::UTX::Implementation::Handler::Format::UTX::Simple
            - Text::UTX::Implementation::Parser::UTX::Simple::V0_90
            - Text::UTX::Implementation::Parser::UTX::Simple::V0_91
            - Text::UTX::Implementation::Parser::UTX::Simple::V0_92
            - Text::UTX::Implementation::Parser::UTX::Simple::V1_00
            - Text::UTX::Implementation::Dumper::UTX::Simple::V0_90
            - Text::UTX::Implementation::Dumper::UTX::Simple::V0_91
            - Text::UTX::Implementation::Dumper::UTX::Simple::V0_92
            - Text::UTX::Implementation::Dumper::UTX::Simple::V1_00
        - Text::UTX::Implementation::Format::UTX::XML
            - Text::UTX::Implementation::Handler::Format::UTX::XML
            - Text::UTX::Implementation::Parser::UTX::XML
            - Text::UTX::Implementation::Dumper::UTX::XML

    * Implementations/Streams
        - Text::UTX::Implementation::Stream::Memory
            - Text::UTX::Implementation::Handler::Stream::Memory
            - Text::UTX::Implementation::Loader::Memory
            - Text::UTX::Implementation::Saver::Memory
        - Text::UTX::Implementation::Stream::LWP::UserAgent
            - Text::UTX::Implementation::Handler::Stream::LWP::UserAgent
            - Text::UTX::Implementation::Loader::LWP::UserAgent
            - Text::UTX::Implementation::Saver::LWP::UserAgent
        - Text::UTX::Implementation::Stream::Path::Class
            - Text::UTX::Implementation::Handler::Stream::Path::Class
            - Text::UTX::Implementation::Loader::Path::Class
            - Text::UTX::Implementation::Saver::Path::Class

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

The full text of the license can be found in the F<LICENSE> file
included with this distribution.

=cut
