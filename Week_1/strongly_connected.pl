#!/usr/bin/perl

use strict;
use warnings;
use Graph;
use Paths;
use Data::Dumper;

my $graph = Graph->new(13, 1, [[0,1], [0,5], [2,0], [2,3], [3,2], [3,5], [4,3], [4,2], [5,4],
                              [6,0], [6,8], [6,4], [6,9], [7,6], [7,9], [8,6], [9,10], [9,11], 
                               [10,12], [11,12], [12,9], [11,4]]);

my $path = Paths->new($graph,0);
$path->kosaraju_sharir;
for (0 .. 12) {
  print "Group for $_ is: " . $path->id($_) . "\n";
}
