
package RTF::Reader::Style;

	use strict;
	use warnings;

	my @parprops = qw(s f hyphpar intbl itap keep keepn level noline nowidctlpar widctlpar outlinelevel pagebb sbys qc qj ql qr qd faauto fahang facenter faroman favar fafixed fi cufi li lin culi ri rin curi adjustright sb sa sbauto saauto lisb lisa sl slmult nosnaplinegrid subdocument rtlpar ltrpar nocwrap nowwrap nooverflow aspalpha aspnum collapsed );
	my @charprops = qw(f b cb cchs cf charscalex cs cgrid g gcw gridtbl deleted dn embo expnd expndtw fittext fs i impr kerning langfe langfenp lang langnp ltrch rtlch noproof nosupersub nosectexpand outl rtlch scaps shad strike striked sub super ul ulc uld uldash uldashd uldashdd uldb ulhwave ulldash ulnone ulth ulthd ulthdash ulthdashd ulthdashdd ulthldash ululdbwave ulw ulwave up v webhidden);

=head1 NAME

RTF::Reader::Style

=head1 DESCRIPTION

Interface to RTF styles

=head1 OVERVIEW

To (hopefully) make document conversion from RTF easier,
styles are interfaced through a nice clean class of their
own. 

This allows us to take care of stylesheet inheritance
without harrassing you, the user, with the details. An RTF::Reader::Style
object represents a single style in  a document - that is, it represents
an entry in the stylesheet table.

=head1 METHODS

=head2 new

We use this method internally, but maybe it'll be useful to you.
Instantiates a new object.

=cut

sub new {

	my $class = shift;
	
	my $self = {
		attributes => {},
		number     => shift || '0'
	};
	
	bless $self, $class;
	
	return $self;

}

=head2 pard

Clears paragraph properties

=cut

sub pard {

	my $self = shift;
		
	for my $prop (@parprops) {
	
		delete( $self->{attributes}->{ $prop } );
	
	}

}

=head2 plain

Clears character formatting properties

=cut

sub plain {

	my $self = shift;
		
	for my $prop (@charprops) {
	
		delete( $self->{attributes}->{ $prop } );
	
	}

}

=head2 clone

Clone's the current style...

=cut

sub clone {

	my $self = shift;
	
	my $new_self = {
		attributes => { %{ $self->{attributes} } },
		number     => $self->{number}
	};
	
	bless $new_self, ref($self);
	
	return $new_self;

}

=head2 nuke

Clear a style's attributes

=cut

sub nuke {

	my $self = shift;
	
	$self->{attributes} = {};

}

=head2 number

Sets/gets the number of the style

=cut

sub number {

	my $self = shift;
	
	$self->{number} = $_[0] if $_[0];
	
	$self->{ attributes }->{'s'} = $self->{ number };
	
	return $self->{number};

}

=head2 parent

Accessor for defining inheritance. We don't know what order styles
will be set in, so this is just an integer.

=cut

sub parent {

	my $self = shift;
	
	$self->{parent} = $_[0] if $_[0];
	
	return $self->{parent};

}

=head2 name

Accessor for defining the style's 'Name'. For example 'Default Paragraph Font'.

=cut

sub name {

	my $self = shift;
	
	$self->{name} = $_[0] if $_[0];
	
	return $self->{name};

}

=head2 get

Retrieves the value of a formatting property. If it's undefined,
and we have a parent set, we check the parent value, and so on.

=cut

sub get {

	my $self = shift;
	my $key = shift;
	
	return $self->{attributes}->{$key};

}

=head2 set

Sets the value of a formatting property. You're unlikely to need
to play with this method, but, it seems worth documenting and
making public just incase you do.

=cut

sub set {

	my $self = shift;
	my $key = shift;
	my $value = shift;
	
	$self->{attributes}->{$key} = $value;

}

=head1 FORMATTING PROPERTIES

As per the RTF spec. Sorry, this is documentation for my object,
not RTF in general ;-)

=cut

1;