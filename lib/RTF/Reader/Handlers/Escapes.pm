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

		'rquote' => sub { my $self = shift; treat_as_text( $self->reader, "'" ); },
		'lquote' => sub { my $self = shift; treat_as_text( $self->reader, "'" ); },
		'rdblquote' => sub { my $self = shift; treat_as_text( $self->reader, '"' ); },
		'ldblquote' => sub { my $self = shift; treat_as_text( $self->reader, '"' ); },

		'\\' => sub {

			my $self = shift;
			
			treat_as_text( $self->reader, '\\' );

		},
		
		"'" => sub {
		
			my $self = shift;
			my $code = shift;
			
			treat_as_text( $self->reader, chr(hex($code)) );
		
		},
		
		uc => sub {
		
			my $self = shift;
			
			$self->unicode_count( shift );
			
		},
		
		u => sub {
		
			my $self = shift;
			my $argument = shift;
			
			$argument += ( 32767 * 2) if $argument < 0;
			
			my $char = chr(  $argument );
			
			treat_as_text( $self->reader,
			
				$char
			
			);
			
			$self->{_CUT_CHARACTERS} = $self->unicode_count() || 1;

		},

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
