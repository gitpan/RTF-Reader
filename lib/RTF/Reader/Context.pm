
package RTF::Reader::Context;

	use strict;
	use warnings;
	
=head1 NAME

RTF::Reader::Context

=head1 DESCRIPTION

A place in an RTF document

=head1 METHODS

=head2 new

Creates a new context. If you call this on an object, it'll
create a child of that object.

=cut

sub new {

	my $self = shift;
	
	my $child = {
		attribute => {}
	};
	
	if ( ref($self) ) {
	
		bless $child, ref( $self );
		$child->{_PARENT} = $self;
		$child->{_READER} = $self->{_READER};
		$child->{_SHOULD_BUFFER} = $self->{_SHOULD_BUFFER};
		$child->{_INHERITED_ON_DESTROY} = $self->{_INHERITED_ON_DESTROY};
		$child->{attribute} = $self->{attribute};
		$child->context( $self->context );

		if ( $self->{style} ) {
			$child->{style} = $self->{style}->clone;
		} else {
			$child->{style} = RTF::Reader::Style->new;
		}
	
	} else {
	
		bless $child, $self;
	
	}
	
	return $child;

}

=head2 toggle_buffering

Pass it a true or false value, depending what you want to do. If it's off,
then text will get passed straight up to RTF::Reader::add_to_text. If it's
on, it won't, and we have to wait until it's flushed to play with it.

=cut

sub toggle_buffering {

	my $self = shift;
	my $toggle = $_[0] || 0;
	
	$self->{_SHOULD_BUFFER} = $toggle;

}

=head2 add_to_text

Adds to the text buffer

=cut

sub add_to_text {

	my $self = shift;
	
	my $text = shift;
		
	if ( $self->{_SHOULD_BUFFER} ) {
		
		$self->{_TEXT_BUFFER} .= $text;

	} else {
	
		$self->reader->add_text( $text );
	
	}

}

=head2 flush_text

Returns and clears the text buffer

=cut

sub flush_text {

	my $self = shift;
	
	my $text = $self->{_TEXT_BUFFER};
		
	$self->{_TEXT_BUFFER} = '';
	
	return $text;

}

=head2 spawn

Create a child context

=cut

sub spawn {

	my $self = shift;

	return $self->new;
	
}

=head2 destroy

Calls all of the context's 'on_destroy' routines, and then
returns its parent.

=cut

sub destroy {

	my $self = shift;

	my @calls;
	
	@calls = ( @{ $self->{_ON_DESTROY} } ) if $self->{_ON_DESTROY};
	@calls = ( @calls, @{ $self->{_INHERITED_ON_DESTROY} } ) if $self->{_INHERITED_ON_DESTROY};

	@calls = sort { $a->[0] <=> $b->[0] } @calls;
	
	for (@calls) {	
	
		my $call = $_->[1];
	
		$call->( $self );
	
	}
	
#	# Flush text if we have a handler...
#	if ( $RTF::Reader::text_handler{ $self->context } ) {
#	
#		$RTF::Reader::text_handler{ $self->context }->(
#		
#			$self->flush_text
#		
#		)
#	
#	}
	
	# Text we wanted to save shouldn't be buffered,
	# so I'm turning off this auto-flushing...
	
	#my $text = $self->flush_text;	
	#$self->reader->add_text( $text );
	
	return $self->parent;

}

=head2 parent

Returns an object's parent

=cut

sub parent {

	my $self = shift;
	
	return $self->{_PARENT};

}

=head2 reader

Returns an object's parent

=cut

sub reader {

	my $self = shift;
	my $reader = shift;
	
	$self->{_READER} = $reader if $reader;
	
	return $self->{_READER};

}

=head2 context

Holds a context string, which is free-form. This is just an accessor.

=cut

sub context {

	my $self = shift;
	
	my $context = shift;

	$self->{_CONTEXT} = $context if $context;
	
	return $self->{_CONTEXT};

}

=head2 on_destroy

Adds a method call to the ones process when the context is
destroyed...

=cut

sub on_destroy {

	my $self = shift;
	
	my $method = shift;

	$self->{_ON_DESTROY} = [] unless $self->{_ON_DESTROY};

	push( @{ $self->{_ON_DESTROY} }, $method );

}

=head2 inherited_on_destroy

Adds a method call to the ones process when the context is
destroyed, only this is inherited in child contexts.

=cut

sub inherited_on_destroy {

	my $self = shift;
	
	my $method = shift;

	$self->{_INHERITED_ON_DESTROY} = [] unless $self->{_INHERITED_ON_DESTROY};

	push( @{ $self->{_INHERITED_ON_DESTROY} }, $method );

}

1;
