package RTF::Reader::Handlers::Escapes;

	use strict;
	use warnings;
	
	our %handler = (

    'tab' => sub {

      my $self = shift;

      treat_as_text( $self->reader, "\t" );

    },

		'_' => sub {
		
			my $self = shift;
			
			treat_as_text( $self->reader, '-' );
		
		},

    '~' => sub {

      my $self = shift;

      treat_as_text( $self->reader, ' ' );

    },

    '-' => sub {

      my $self = shift;

      treat_as_text( $self->reader, '-' );

    },

		'\\' => sub {

			my $self = shift;
			
			treat_as_text( $self->reader, '\\' );

		},
		
		"'" => sub {
		
			my $self = shift;
			my $code = shift;
			
			treat_as_text( $self->reader, chr(hex($code)) );
		
		}

	);
	
	sub treat_as_text {
		
		my $self = shift;
		my $token = shift;
		
		#if ( my $sub = $RTF::Reader::text_handler{ $self->{context}->context } ) {
			
		#	$sub->( $self, $token );
			
		
		#} else {
			
			$self->{context}->add_to_text( $token );
			
	
		#}
	
	}
	
1;
