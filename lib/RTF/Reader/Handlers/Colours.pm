package RTF::Reader::Handlers::Colours;

	use strict;
	use warnings;
	
	our %handler = (

# So, colour tables... Now, there are two ways this *could* be done.
# The really simple way would be to stop parsing RTF, and read in until
# the end of the group, parse it like a string, and just use a regex to
# get the colour values out. HOWEVER. I'm fairly sure I should be able
# to call events on bits of text in the right context, so, that's what
# I'll do.
	
colortbl => sub {

	my $self = shift;
	
	# Turn on text buffering...
	$self->toggle_buffering(1);
	
	# This is a destination, so, we're going
	# to change the context...
	
	$self->context( 'colour table' );

},

red =>   sub { my $self = shift; $self->{attribute}->{red} = shift; },
green => sub { my $self = shift; $self->{attribute}->{green} = shift; },
blue =>  sub { my $self = shift; $self->{attribute}->{blue} = shift; },


	);
	
1;