package RTF::Reader::Handlers::Stylesheet;

=head1 Rambling

Some thoughts on style sheets as I go through the document...

At any point, I'm going to want the 'current style' that's easily
accessible. So what I'm going to need is a style object that says
what the:

style number is

current style formatting options are

That'll take care of 
'basedon', 'additive', 'pard', 
'sectd', 'plain'
and will also revert back when the current group ends.

This shouldn't be all that hard. To do this, I need an idea of what
the paragraph formatting options are and the section ones, so I can
easily clear them, encountering a new style should work out what to
do next.

These should be implemented as style methods, as far as possible.
'basedon' is irrelevant to us, as we're going to be shown the 
styling anyway. 'additive' is important, because it lets us know
if we should clear other formatting first ... is that right? It
must be. So when we come across a style that isn't additive, 
presumably we nuke our current style defs with the style specified,
when it additive, we just cycle through the keys.

So to implement this, I need a list of paragraph formatting commands
and section formatting commands.

=cut

	use strict;
	use warnings;
	
	use Data::Dumper;
	
	our %handler = (

# Scary.
	
stylesheet => sub {

	my $self = shift;

	# Turn on text buffering...
	$self->toggle_buffering(1);
	
	# This is a destination, so, we're going
	# to change the context...
	
	$self->context( 'style sheet' );

	$self->{'style'} = RTF::Reader::Style->new( 0 );

	# We need a destroy handler that takes the style object in
	# /this/ context and turns it into \s0
		$self->inherited_on_destroy(
	
			[ 10, sub {
	
				my $self = shift;
				
				# We're looking for the non-marked style. If
				# a style was created using s, cs, or ds, it'll
				# have a number, so it's not the right one.
				
				return if $self->{'style'}->{number};
				
				# And check we're not getting caught by 'style sheet's
				# on_destroy handler...
				
				return unless 
					$self->parent->context eq 'style sheet' &&
					$self->context eq 'style sheet';
				
				$self->{'style'} = $self->parent->{style}
					unless $self->{'style'};
				
				my $style_name = $self->flush_text;
				$style_name =~ s/;//g;
				$style_name =~ s/^\s+//;
								
				$self->{'style'}->name( $style_name );
				
				$self->reader->{styles}->{ '0' } =
					$self->{style};
								
			} ]
		
		);	

},

# s, cs, ds -- style number defs

's'  => sub{&start_def},
'cs' => sub{&start_def},
'ds' => sub{&start_def},
'sbasedon' => sub{&set_based_on},
'plain'    => sub { my $self = shift; $self->{style}->plain; }

	);



eval "\$handler{'$_'} = sub {RTF::Reader::Handlers::Stylesheet::toggle_style_property('$_', \@_)};" for qw( additive snext sautoupd shidden spersonal scompose sreply brdrt brdrb brdrl brdrr brdrbtw brdrbar box brdrs brdrth brdrsh brdrdb brdrdot brdrdash brdrhair brdrinset brdrdashsm brdrdashd brdrdashdd brdroutset brdrtriple brdrtnthsg brdrthtnsg brdrtnthtnsg brdrtnthmg brdrthtnmg brdrtnthtnmg brdrtnthlg brdrthtnlg brdrwavy brdrwavydb brdrdashdotstr brdremboss brdrengrave brdrframe brdrw brdrcf brsp hyphpar intbl itap keep keepn level noline nowidctlpar widctlpar outlinelevel pagebb sbys qc qj ql qr qd faauto fahang facenter faroman favar fafixed fi cufi li lin culi ri rin curi adjustright sb sa sbauto saauto lisb lisa sl slmult nosnaplinegrid subdocument rtlpar ltrpar nocwrap nowwrap nooverflow aspalpha aspnum collapsed absw absh phmrg phpg phcol posx posnegx posxc posxi posxo posxr posxl pvmrg pvpg pvpara posy posnegy posyil posyt posyc posyb posyin posyout abslock nowrap dxfrtext dfrmtxtx dfrmtxty overlay dropcapli dropcapt absnoovrlp frmtxlrtb frmtxtbrl frmtxbtlr frmtxlrtbv frmtxtbrlv tx tqr tqc tqdec tb tldot tlmdot tlhyph tlul tlth tleq shading bghoriz bgvert bgfdiag bgbdiag bgcross bgdcross bgdkhoriz bgdkvert bgdkfdiag bgdkbdiag bgdkcross bgdkdcross cfpat cbpat cb cchs cf charscalex cgrid g gcw gridtbl deleted dn embo expnd expndtw fittext fs i impr kerning langfe langfenp lang langnp ltrch rtlch noproof nosupersub nosectexpand outl rtlch scaps shad strike striked sub super ul ulc uld uldash uldashd uldashdd uldb ulhwave ulldash ulnone ulth ulthd ulthdash ulthdashd ulthdashdd ulthldash ululdbwave ulw ulwave up v webhidden
);


sub set_based_on {

	my $self = shift;
	my $value = shift;
	
	$self->{'style'}->parent( $value );	

}

sub toggle_style_property {

	my $property = shift;
	my $self = shift;
	my $value = shift;
	
	#if (( $self->context eq 'style sheet' ) || ( $self->context eq 'style definition' ) ) {
	
		# It's a toggle...
		$value = 1 if $value eq '';
	
		$self->{'style'}->set( $property, $value );

	#}

}

sub start_def {

	my $self = shift;
	my $value = shift;
	
	if ( $self->context eq 'style sheet' ) {
	
		$self->{style}->number( $value );
	
		$self->context( 'style definition' );
			
		# Add an on_destroy method to collect here.
		$self->on_destroy(
	
			[ 10, sub {
	
				my $self = shift;
				
				my $style_name = $self->flush_text;
				$style_name =~ s/;//g;
				$style_name =~ s/^\s+//;
				
				$self->{style}->name( $style_name );

				
				$self->reader->{styles}->{ $self->{style}->{number} } =
					$self->{style};
						
			} ]
		
		);
	
	# We're encountering a style def in a document
	} else {
	
		# Nuke currently held attributes
		$self->{style}->nuke() unless $self->reader->{styles}->{ $self->{style}->number }->{attributes}->{additive};
		
		# Set the number
		$self->{style}->number( $value );
			
	}

}

sub property {

	my $self = shift;

}

1;