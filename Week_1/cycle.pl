#!/usr/bin/perl

use strict;
use warnings;
use Graph;
use Paths;

# Cyclic.
my $graph = Graph->new(4, 1, [[0,1], [1,2], 
                              [2,3], [3,0]]);

my $path = Paths->new($graph,0);
if ($path->has_cycle) {
  my @cycle = @{$path->{cycle}};
  print "Cycle - @cycle\n";
} else {
  print "No cycle\n";
}

# No cycle.
my $graph2 = Graph->new(4, 1, [[0,1], [0,3], 
                               [3,2], [1,2]]);

my $path2 = Paths->new($graph2,0);
if ($path2->has_cycle) {
  my @cycle = @{$path2->{cycle}};
  print "Cycle - @cycle\n";
} else {
  print "No cycle\n";
}

my $graph3 = Graph->new(6, 1, [[0,1], [1,2], [2,3], [3,0], [1,4], [4,5], [5,1]]);

my $path3 = Paths->new($graph3,0);
if ($path3->has_cycle) {
  my @cycle = @{$path3->{cycle}};
  print "Cycle - @cycle\n";
} else {
  print "No cycle.\n";
}
