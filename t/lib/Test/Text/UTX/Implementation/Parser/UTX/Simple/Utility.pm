package Test::Text::UTX::Implementation::Parser::UTX::Simple::Utility;


# ****************************************************************
# pragmas
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use List::MoreUtils qw(apply);


# ****************************************************************
# 
# ****************************************************************

sub dump_utx_simple_as_string {
    my ($self, %complement) = @_;

    return sprintf(
        "#%s %s; %s; %s;%s\n"
      . "#%s\n"
      . "%s\n",
            # line 0
            defined $complement{specification}
                        ? $complement{specification}
                        : $self->default_string('specification'),
            defined $complement{version}
                        ? $complement{version}
                        : $self->default_string('version'),
            defined $complement{alignment}
                        ? $complement{alignment}
                        : $self->default_string('alignment'),
            defined $complement{last_modified}
                        ? $complement{last_modified}
                        : $self->default_string('last_modified'),
            defined $complement{miscellanies}
                        ? $complement{miscellanies}
                        : $self->default_string('miscellanies'),
            # line 1
            defined $complement{columns}
                        ? ( join "\t", @{ $complement{columns} } )
                        : $self->default_string('columns'),
            # line 2+
            defined $complement{entries}
                        ? ( join "\n", @{ $complement{entries} } )
                        : $self->default_string('entries'),
    );
}


# ****************************************************************
# 
# ****************************************************************

sub default_string {
    my ($self, $kind) = @_;

    return $kind eq 'specification' ? 'UTX-S'
         : $kind eq 'version'       ? '1.00'
         : $kind eq 'alignment'     ? 'en/eo'
         : $kind eq 'last_modified' ? '2010-01-01T00:00:00Z'
         : $kind eq 'miscellanies'  ? 'foo: bar; baz: qux;'
         : $kind eq 'columns'       ? ( join "\t", qw(src tgt src:pos) )
         : $kind eq 'entries'       ? ( join "\n",
                                            "hellow\tsaluton\t",
                                            "world\tmondo\t", )
         : wantarray                ? ()
         :                            undef;
}

sub default_structure {
    my ($self, $kind) = @_;

    return $kind eq 'specification' ? 'UTX-S'
         : $kind eq 'version'       ? '1.00'
         : $kind eq 'alignment'     ? $self->structure_of_alignment
         : $kind eq 'last_modified' ? '2010-01-01T00:00:00Z'
         : $kind eq 'miscellanies'  ? 'foo: bar; baz: qux;'
         : $kind eq 'columns'       ? ( join "\t", qw(src tgt src:pos) )
         : $kind eq 'entries'       ? ( join "\n",
                                            "hellow\tsaluton\t",
                                            "world\tmondo\t", )
         : wantarray                ? ()
         :                            undef;
}


# ****************************************************************
# expected structures
# ****************************************************************

sub structure_of_alignment {
    my ($self, $string) = @_;

    $string = $self->default_string('alignment') unless defined $string;

    my %alignment;
    @alignment{qw(source target)} = split '/', $string;

    return \%alignment;
}

sub structure_of_columns {
    my ($self, $string) = @_;

    $string = $self->default_string('columns') unless defined $string;

    $string =~ s{ \A \# }{}xms;

    return [
        apply {
            s{ \A src (?= $ | :) }{source}xmsg;
            s{ \A tgt (?= $ | :) }{target}xmsg;
            s{ : }{_}xmsg;
        } split "\t", $string
    ];
}

sub structure_of_last_modified {
    my ($self, $string) = @_;

    $string = $self->default_string('last_modified') unless defined $string;

    return $string;
}

sub structure_of_miscellanies {
    my ($self, $string) = @_;

    $string = $self->default_string('miscellanies') unless defined $string;

    return [ split m{ \s* [:;] \s* }xms, $string ];
}

sub structure_of_entries {
    my ($self, $string) = @_;

    $string = $self->default_string('entries') unless defined $string;

    return [
        map {
            my $is_comment = $_ =~ s{ \A \# }{}xms;
            my @columns    = split m{ \t }xms, $_;
            {
                is_comment => $is_comment,
                columns    => \@columns,
            };
        } split m{ \r? \n }xms, $string
    ];
}


# ****************************************************************
# 
# ****************************************************************

sub dump_utx_simple_as_arrayref {
    my ($self, %complement) = @_;

    return {
        alignment
            => $self->structure_of_alignment($complement{alignment}),
        last_modified
            => $self->structure_of_last_modified($complement{last_modified}),
        miscellanies
            => $self->structure_of_miscellanies($complement{miscellanies}),
        columns
            => $self->structure_of_columns($complement{columns}),
        entries
            => $self->structure_of_entries($complement{entries}),
    };
}


# ****************************************************************
# 
# ****************************************************************

sub parsing_string {
    my $self = shift;

    return $self->dump_utx_simple_as_string(@_);
}

sub parsing_arrayref {
    my $self = shift;

    return [
        split m{ \r? \n }xms,
            $self->parsing_string(@_)
    ];
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

Test::Text::UTX::Implementation::Parser::UTX::Simple::Utility -

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
