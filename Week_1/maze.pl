#!/usr/bin/perl

use strict;
use warnings;
use UDGraph;
use Paths;

my $graph = UDGraph->new(20, [[0,1],  [0,14], 
                              [1,4],  [1,2],
                              [2,3],  [2,6], 
                              [3,10], [4,7],
                              [5,6],  [6,9],
                              [7,8],  [8,11],
                              [9,10], [10,13],
                              [11,12], [12,16],
                              [14,15],  [16,17],
                              [17,18], [16,19],]);

my $path = Paths->new($graph,1);
$path->depth_first;
my @path = $path->path_to(19);
print "@path\n";

$path->clean;

$path->breadth_first;
@path = $path->path_to(19);
print "@path\n";
