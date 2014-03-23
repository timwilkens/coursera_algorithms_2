#!/usr/bin/perl

use strict;
use warnings;
use Graph;
use Paths;

# Bipartite. Simple rectangular graph.
my $graph = Graph->new(6, undef, [[0,1], [0,3], 
                                  [1,2], [2,5],
                                  [5,4], [4,3]]);

# Non-Bipartite. Completely connected square.
my $non_bi_g = Graph->new(4, undef, [[0,1], [0,2],
                                     [0,3], [1,2],
                                     [1,3], [2,3]]);

for my $g ($graph, $non_bi_g) {
  my $path = Paths->new($g,0);
  if ($path->is_bipartite) {
    print "Bipartite\n";
  } else {
    print "Not Bipartite\n";
  }
}

