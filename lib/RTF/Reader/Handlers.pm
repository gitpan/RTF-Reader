
package RTF::Reader::Handlers;

	use strict;
	use warnings;
	
	use RTF::Reader::Handlers::Fonts;
	use RTF::Reader::Handlers::Colours;
	use RTF::Reader::Handlers::Stylesheet;
	use RTF::Reader::Handlers::Info;
	use RTF::Reader::Handlers::Escapes;
	
	our %handler = (

		%RTF::Reader::Handlers::Fonts::handler,	
		%RTF::Reader::Handlers::Colours::handler,
		%RTF::Reader::Handlers::Stylesheet::handler,
		%RTF::Reader::Handlers::Info::handler,
		%RTF::Reader::Handlers::Escapes::handler,

		par => sub {
		
			my $self = shift;
			
			# This is a bad way to do this...
			$self->reader->{tokenizer}->put_token( 'text', "\n" );
		
		},
		
		pard => sub {
		
			my $self = shift;
			
			$self->{style}->pard();
			
			# This is a bad way to do this...
		#	$self->reader->{tokenizer}->put_token( 'text', "\n" );
		
		},

		pict => sub {

			my $self = shift;
	
			# Turn on text buffering...
			$self->toggle_buffering(1);
	
			# This is a destination, so, we're going
			# to change the context...
	
			$self->context( 'embedded picture' );

		},
		


	
	);


		# Special destination handler...
		
	$handler{'*'} = sub {
		
			my $self = shift;
		
			# Grab a copy of the tokenizer so we don't need to
			# keep dereferencing it...
			
				my $tokenizer = $self->reader->{tokenizer};
			
			# Grab the next token
 			
 				my ( $token_type, $token_argument, $token_parameter)
 					= $tokenizer->get_token();
 				
 			# Basic sanity check
 			
 				croak('Malformed RTF - \* not followed by a control...')
 					unless $token_type eq 'control';
 						
 			# Do we have a handler for it?
				
				if ( defined $handler{$token_argument} ) {
				
				# Stick it back on the stack...
				
					$tokenizer->put_token( $token_type, $token_argument, $token_parameter )
				
				} else {
				
					my $level_counter = 1;
		
					while ( $level_counter ) {
		
					# Get a token
						my ( $token_type, $token_argument, $token_parameter)
 							= $tokenizer->get_token();
		
					# Make sure we can't loop forever
						last if $token_type eq 'eof';
				
					# We're in business if it's a group
						if ($token_type eq 'group') {
				
							$token_argument ?
								$level_counter++ :
								$level_counter-- ;
				
						}
						
					}
					
				# We're out of the loop, so presumably we just ate a },
				# which we'll now return to the stack...
		
					$tokenizer->put_token( 'group', 0, '' )
		
				}
		
	};

1;
