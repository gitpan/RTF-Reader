#!/usr/bin/perl

use lib '../lib';
    use utf8;

use RTF::Reader;
use Data::Dumper;

use strict;
use warnings;
	
	my $object = RTF::Reader->new( file => $ARGV[0] );
	
#	binmode(STDOUT, ":utf8");	
#	binmode(STDERR, ":utf8");
	$object->process;
	print $object->{buffer};

