#!/usr/bin/perl

use strict;
use warnings;
use Graph;
use Paths;

my $graph = Graph->new(7, 1, [[0,2], [0,5], [0,1], [0,4], [3,2], [3,5], [3,6], [3,4], 
                              [5,2], [6,0], [6,4]]);

my $path = Paths->new($graph,0);
my @topo_order = $path->topological_order;
print "@topo_order\n";
