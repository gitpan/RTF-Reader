package RTF::Reader::Interface::asText;

	use strict;

	use RTF::Reader;
	
=head1 TITLE

RTF::Reader::Interface::asText - Simple RTF to Text conversion

=head1 DESCRIPTION

Stable and very simple interface to RTF::Reader for simple RTF to Text conversion

=head1 JUSTIFICATION

RTF::Reader is no-where near stable, but, it's good enough for use in some
applications. Rather than being stuck with the current interface because
people have started using it, the RTF::Reader::Interface:: modules provide
a stable interface people can use, regardless of what's going on in the
background.

The 'asX' modules provide very simple and dirty RTF conversion - the idea
being that if you want to do something very simply, it really shouldn't
involve a lot of setup. 

=head1 SYNOPSIS

 use RTF::Reader::Interface::asText;
 
 my $text = RTF::Reader::Interface::asText::convert( string => '{\rtf1}'  );
 my $text = RTF::Reader::Interface::asText::convert( file   => \*STDIN    );
 my $text = RTF::Reader::Interface::asText::convert( file   => 'lala.rtf' );

=head1 SUBROUTINES

=head2 convert

Accepts an input filehandle, file, or string. See the L<SYNOPSIS> above
for examples.

Returns a plain-text rendering of the text.

=cut

# So in fact, it's marginally more complicated than the docs let on, but
# that's life.

sub convert {

	my $object = RTF::Reader->new( @_ );
	$object->process;
	return $object->{buffer};

}

=head1 AUTHOR

Peter Sergeant - pete@clueball.com

=head1 LICENSE

As Perl.

=cut

1;
