#!/usr/bin/env perl

# concordance.pl - rudimentary KWIC search engine

# Eric Lease Morgan <eric_morgan@infomotions.com>
# June    7, 2009 - first investigations using Lingua::Concordance
# August 29, 2010 - added cool bar chart
# August  2, 2020  - tweaked to be study-carrel specific; easier to use but less flexible


# configure
use constant LIBRARY => './library';
use constant CORPUS  => 'etc/reader.txt';
use constant RADIUS  => 40;

# include
use lib './lib';
use Lingua::Concordance;
use Text::BarGraph;
use strict;

# sanity check
my $carrel = $ARGV[ 0 ];
my $query  = $ARGV[ 1 ];
if ( ! $carrel or ! $query ) {

	print "Usage: $0 <carrel> <regular_expression>\n";
	exit;
	
}

# initialize
my $library = LIBRARY;
my $corpus  = CORPUS;
my $file    = "$library/$carrel/$corpus";

# slurp
open INPUT, "$file" or die "Can't open $file: $!\n";
my $text = do { local $/; <INPUT> };
close INPUT;

# configure
my $concordance = Lingua::Concordance->new;
$concordance->text( $text );
$concordance->query( $query );
$concordance->radius( RADIUS );
$concordance->sort( 'none' );
$concordance->ordinal( 1 );

# do the work
print "Snippets from $file containing $query:\n";
foreach ( $concordance->lines ) { print "  * $_\n" }
print "\n";

# graph where the query is located in the text
print "A graph illustrating in what percentage of $file $query is located:\n";
my $barchart = Text::BarGraph->new();
$barchart->autosize( 0 );
$barchart->columns( 40 );
$barchart->sorttype( "numeric" );
$barchart->enable_color( 1 );
print $barchart->graph( $concordance->map );
print "\n";

# done
exit
