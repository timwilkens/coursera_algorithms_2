package UDGraph;

use strict;
use warnings;

sub new {
  my ($class, $num_of_vertices, $edges) = @_;

  my %self;
  $self{V} = $num_of_vertices;
  $self{E} = 0;
  $self{adj} = [];

  for my $i (0 .. ($num_of_vertices - 1)) {
    $self{adj}[$i] = [];
  }

  my $graph = bless \%self, $class;

  if ($edges) {
    for my $edge (@$edges) {
      $graph->add_edge($edge->[0], $edge->[1]);
    }
  }

  return $graph;
}

sub add_edge {
  my ($self, $v, $w) = @_;

  push @{$self->{adj}[$v]}, $w;
  push @{$self->{adj}[$w]}, $v;

  $self->{E}++;
}


sub adj {
  my ($self, $vertex) = @_;

  return @{$self->{adj}[$vertex]};
}

1;
