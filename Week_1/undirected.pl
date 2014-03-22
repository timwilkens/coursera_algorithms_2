#!/usr/bin/perl

use strict;
use warnings;
use UDGraph;
use Paths;

my $graph = UDGraph->new(13, [[0,1],  [0,2], 
                              [0,6],  [0,5],
                              [6,4],  [4,3], 
                              [4,5],  [3,5],
                              [7,8],  [9,10],
                              [9,11], [9,12], 
                              [11,12]]);

my $path = Paths->new($graph,5);
$path->depth_first;

for (qw( 0 1 2 3 4 5 6 7 8 9 10 11 12 )) {
  my @path = $path->path_to($_);
  if (defined $path[0]) {
    print "@path\n";
  } else {
    print "No path to $_\n";
  }
}