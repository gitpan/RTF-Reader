package RTF::Reader::Handlers::Fonts;

	use strict;
	use warnings;
	
	our %handler = (
	
fonttbl => sub {

	my $self = shift;
	
	# Turn on text buffering...
	$self->toggle_buffering(1);
	
	# This is a destination, so, we're going
	# to change the context...
	
	$self->context( 'font table' );

},

f => sub {

	my $self = shift;
	my $number = shift;
	
	if ( $self->context eq 'font table' ) {

		$self->context('font definition');
		
		$self->{attribute}->{font} = $number;
		
		$self->{attribute}->{font_object} = RTF::Reader::Font->new();

		$self->on_destroy(
	
			[ 10, sub {
	
				my $self = shift;
				
				my $font_name = $self->flush_text;
				$font_name =~ s/;//g;
				$self->{attribute}->{font_object}->name( $font_name );

				
				$self->reader->{fonts}->{ $self->{attribute}->{font} } =
					$self->{attribute}->{font_object};
						
			} ]
		
		);

	} else {
		
		my $self = shift;
		
		$self->{style}->{attributes}->{f} = $number;
	
	}

},

panose => sub {

	my $self = shift;
		
	if ( $self->context eq 'font definition' ) {
	
		$self->context('panose');
		$self->on_destroy([ 10, sub {
		
			my $self = shift;
			$self->parent->{attribute}->{font_object}->panose( $self->flush_text );
		
			} ]
	
		);

	}

},

fname => sub {

	my $self = shift;
		
	if ( $self->context eq 'font definition' ) {
	
		$self->context('non-tagged font name');
		$self->on_destroy([ 10, sub {
		
			my $self = shift;
			$self->parent->{attribute}->{font_object}->no_tagged_name( $self->flush_text );
		
			} ]
	
		);

	}

},


falt => sub {

	my $self = shift;
		
	if ( $self->context eq 'font definition' ) {
	
		$self->context('alternative font name');
		$self->on_destroy([ 10, sub {
		
			my $self = shift;
			$self->parent->{attribute}->{font_object}->alternative_name( $self->flush_text );
		
			} ]
	
		);

	}

},

fnil     => sub { RTF::Reader::Handlers::Fonts::font_family( 'nil', @_ ) },
froman   => sub { RTF::Reader::Handlers::Fonts::font_family( 'roman', @_ ) },
fswiss   => sub { RTF::Reader::Handlers::Fonts::font_family( 'swiss', @_ ) },
fmodern  => sub { RTF::Reader::Handlers::Fonts::font_family( 'modern', @_ ) },
fscript  => sub { RTF::Reader::Handlers::Fonts::font_family( 'script', @_ ) },
fdecor   => sub { RTF::Reader::Handlers::Fonts::font_family( 'decor', @_ ) },
ftech    => sub { RTF::Reader::Handlers::Fonts::font_family( 'tech', @_ ) },
fbidi    => sub { RTF::Reader::Handlers::Fonts::font_family( 'bidi', @_ ) },

fcharset  => sub { RTF::Reader::Handlers::Fonts::simple_definition_attributes( 'charset', @_ ) },
fprq      => sub { RTF::Reader::Handlers::Fonts::simple_definition_attributes( 'pitch', @_ ) },
cpg      => sub { RTF::Reader::Handlers::Fonts::simple_definition_attributes( 'codepage', @_ ) },





	);


sub simple_definition_attributes {

	my $attribute = shift;
	my $self = shift;
	my $value = shift;
		
	if ( $self->context eq 'font definition' ) {
	
		$self->parent->{attribute}->{font_object}->$attribute( $value );
		
	}

}

sub font_family {

	my $family = shift;
	my $self = shift;

	if ( $self->context eq 'font definition' ) {
	
		$self->parent->{attribute}->{font_object}->family( $family )
	
	}

}
	
1;