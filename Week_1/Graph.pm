package Graph;

use strict;
use warnings;

sub new {
  my ($class, $num_of_vertices, $bi, $edges) = @_;

  my %self;
  $self{V} = $num_of_vertices;
  $self{E} = 0;
  $self{adj} = [];
  $self{bi} = $bi;

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
  if (!$self->{bi}) { # Add other direction if no directed.
    push @{$self->{adj}[$w]}, $v;
  }

  $self->{E}++;
}

sub adj {
  my ($self, $vertex) = @_;

  return @{$self->{adj}[$vertex]};
}

sub reverse {
  my $self = shift;

  return unless $self->{bi};

  my $reverse = new('Graph', $self->{V}, 1);

  for my $v (0 .. scalar(@{$self->{adj}} - 1)) {
    for my $w (@{$self->{adj}[$v]}) {
      $reverse->add_edge($w, $v);
    }
  }
  return $reverse;
}

1;
