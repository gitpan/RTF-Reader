#!/usr/bin/perl

use lib '../lib';

use RTF::Reader;
use Data::Dumper;

use strict;
use warnings;
	
	my $object = RTF::Reader->new( file => $ARGV[0] );
	
	$object->process;
	
	print $object->{buffer};

