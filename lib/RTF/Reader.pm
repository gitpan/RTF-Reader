package RTF::Reader;

=head1 NAME

RTF::Reader - Base class for building RTF-processing modules

=head1 DESCRIPTION

Gives you a simple toolset for doing what you want with RTF

=head1 OVERVIEW

B<THIS MODULE IS AT BEST BETA, AT WORST, STILL IN 'PLANNING'. The interface may change, the docs are almost certainly slighty out of date...>

RTF::Reader is a base-class that opens up an API for you to
use to convert RTF into other formats. The basic model is that
you have I<contexts> which represent places in an RTF document,
for which you can define what action is taken when different types
of RTF constructs are encountered.

Before starting, you should also read L<RTF::Reader::Context> to
get a better idea of how to do this.

=head1 METHODS

=cut



	use RTF::Reader::Context;
	use RTF::Reader::Handlers;
	use RTF::Reader::Font;
	use RTF::Reader::Style;

	use RTF::Tokenizer;

	use strict;
	use warnings;
	use Carp;

	use vars qw($VERSION);
	$VERSION = '0.01_1';

	our %handler      = %RTF::Reader::Handlers::handler;
	
	# What we do with text in a given context...
	
	our %text_handler = (
	
		'colour table' => sub {
		
			my $self = shift;
			my $context = $self->{context};
			
			if ( defined $context->{attribute}->{red} ) {
			
				my $color = [ $context->{attribute}->{red}, $context->{attribute}->{green}, $context->{attribute}->{blue}];
		
				push( @{ $self->{colors} }, $color );
				
				delete $context->{attribute}->{red};
				delete $context->{attribute}->{green};
				delete $context->{attribute}->{blue};
			
			} else {
		
				push( @{ $self->{colors} }, [] );
		
			}	
		
		},
		
		'overview' => sub {
		
			my $self = shift;
			my $text = shift;
			
			print $text;
		
		}
	
	);


=head2 new

Instantiate a new object. All arguments are currently passed
to the underlying L<RTF::Tokenizer> instantiator, so you may
want to read the docs for that to understand what you can do.
Note that we're not a subclass of L<RTF::Tokenizer>, we just
store an L<RTF::Tokenizer> object, which we rely on heavily.

=cut

sub new {

	my $class = shift;
	
	my $self = {
	
		tokenizer => RTF::Tokenizer->new( @_ ),
		context   => RTF::Reader::Context->new,
		fonts     => {},
		styles    => {},
		colors    => [],
		buffer    => '',
		info      => {},
	
	};

	bless $self, $class;

	$self->{context}->context('overview');
	$self->{context}->reader( $self );
	
	return $self;

}

=head2 add_text

FIX ME

=cut

sub add_text {

	my $self = shift;
	my $text = shift || '';
	
	$self->{buffer} .= $text;

}

=head2 process

Having defined all your behaviours, you invoke this method
to start the processing of the RTF.

=cut

sub process {

	my $self = shift;

	while ( 1 ) {

		my ( $type, $token, $argument ) = $self->{tokenizer}->get_token();

		last if $type eq 'eof';

		if ( $type eq 'text' ) {

			$self->{context}->add_to_text( $token );

		} elsif ( $type eq 'control' ) {
	
			if ( $handler{ $token } ) {
			
				$self->{last_control} = $token;
	
				$handler{$token}( $self->{context}, $argument );
		
			}
	
		} elsif ( $type eq 'group' ) {

			if ( $token ) {

				$self->{context} = $self->{context}->spawn;

			} else {
			
				$self->{context} = $self->{context}->destroy
				
			}

		}

	}
	
}

=head1 AUTHOR

Peter Sergeant - pete@clueball.com

=head1 LICENSE

As Perl - artistic license.

=cut

1;
