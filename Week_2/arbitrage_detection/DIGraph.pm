package DIGraph;

use strict;
use warnings;
use Edge;

sub new {
  my ($class, $num_of_vertices) = @_;

  my %self;
  $self{V} = $num_of_vertices;
  $self{E} = 0;
  $self{adj} = [];

  for (my $i  = 0;  $i < $num_of_vertices; $i++) {
    $self{adj}[$i] = [];
  }

  bless \%self, $class;
}

sub V { shift->{V} }
sub E { shift->{E} }

sub add_edge {
  my ($self, $from, $to, $weight, $edge);

  if (@_ == 2) {
    ($self, $edge) = @_;
    $from = $edge->from;
    $to = $edge->to;
    $weight = $edge->weight;
  } else {
    ($self, $from, $to, $weight) = @_;
  }

  push @{$self->{adj}[$from]}, Edge->new($from, $to, $weight);
  $self->{E}++;
}

sub adj {
  my ($self, $v) = @_;
  return @{$self->{adj}[$v]};
}

1;
