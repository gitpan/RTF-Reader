package RTF::Reader::Handlers::Info;

	use strict;
	use warnings;
	
	our %handler = (
	
info => sub {

	my $self = shift;
	
	# Turn on text buffering...
	$self->toggle_buffering(1);
	
	# This is a destination, so, we're going
	# to change the context...
	
	$self->context( 'document info' );

},

title     => sub {&grab_data},
author    => sub {&grab_data},
manager   => sub {&grab_data},
company   => sub {&grab_data},
operator  => sub {&grab_data},
category  => sub {&grab_data},
keywords  => sub {&grab_data},
comment   => sub {&grab_data},
doccomm   => sub {&grab_data},
hlinkbase => sub {&grab_data},
subject   => sub {&grab_data},

creatim   => sub { my $self = shift; $self->context( 'info: creatim' ) },
revtim    => sub { my $self = shift; $self->context( 'info: revtim'  ) },
printim   => sub { my $self = shift; $self->context( 'info: printim' ) },
buptim    => sub { my $self = shift; $self->context( 'info: buptim'  ) },

version  => sub {&attribute},
vern     => sub {&attribute},
edmins   => sub {&attribute},
nofpages => sub {&attribute},
nofwords => sub {&attribute},
nofchars => sub {&attribute},
id       => sub {&attribute},

yr =>  sub {&date_field},
mo =>  sub {&date_field},
dy =>  sub {&date_field},
hr =>  sub {&date_field},
min => sub {&date_field},
sec => sub {&date_field},


	);

# Control looks like {\control #PCDATA}

sub grab_data {

	my $self = shift;
		
	$self->on_destroy( [ 10, sub {

		my $self = shift;
		
		my $control = $self->reader->{last_control};

		my $data = $self->flush_text;
		
		$self->reader->{info}->{$control} = $data;	
	
	} ] );
	
}

# Data is in the control's argument

sub attribute {

	my $self = shift;
	my $argument = shift;
	my $control = $self->reader->{last_control};
	
	$self->reader->{info}->{$control} = $argument;

}

sub date_field {

	my $self = shift;
	my $argument = shift;
	my $control = $self->reader->{last_control};
	
	if ( $self->context =~ m/^info: (.+)/ ) {
	
		my $field = $1;
	
		$self->reader->{info}->{$field} = {} unless $self->reader->{info}->{$field};
		$self->reader->{info}->{$field}->{$control} = $argument;
	
	}	

}


1;