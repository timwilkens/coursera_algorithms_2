#!/usr/bin/perl

use strict;
use warnings;
use Graph;
use Paths;

my $graph = Graph->new(4, 1, [[0,1], [0,2], 
                              [2,3], [1,3]]);

my $path = Paths->new($graph,0);
my @topo_order = $path->topological_order;
print "@topo_order\n";
