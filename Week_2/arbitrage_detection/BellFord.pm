package BellFord;

use strict;
use warnings;
use DIGraph;
use Data::Dumper;
use Cycle;

sub new {
  my ($class, $graph, $s) = @_;

  my %self;
  $self{source} = $s;
  $self{graph} = $graph;
  $self{edge_to} = [];
  $self{dist_to} = [];
  $self{queue} = [];
  $self{on_queue} = [];
  $self{cycles} = 0;

  return bless \%self, $class;
}

sub bellman_ford {
  my $self = shift;
  my $graph = $self->{graph};

  for (my $i = 0; $i < $graph->V; $i++) {
    if ($i == $self->{source}) {
      $self->{dist_to}[$i] = 0;
    } else {
      $self->{dist_to}[$i] = 100_000;  # Outside possible weight range.
    }
  }

  push @{$self->{queue}}, $self->{source};
  $self->{on_queue}[$self->{source}] = 1;

  # Change last value to force lower bound on number of edges in cycle.
  while (@{$self->{queue}} && (!$self->has_cycle || scalar(@{$self->{cycle}}) < 5)) {
    my $v = shift @{$self->{queue}};
    $self->{on_queue}[$v] = undef;
    $self->_relax($v);
  }
}

sub has_cycle {
  return shift->{cycle} ? 1 : 0;
}

sub get_cycle {
  my $self = shift;
  return @{$self->{cycle}};
}

sub _relax {
  my ($self, $from) = @_;
  my $graph = $self->{graph};

  for my $edge ($graph->adj($from)) {
    my $to = $edge->to;

    if ($self->{dist_to}[$to] > ($self->{dist_to}[$from] + $edge->weight)) {
      $self->{dist_to}[$to] = $self->{dist_to}[$from] + $edge->weight;
      $self->{edge_to}[$to] = $edge;

      if (!$self->{on_queue}[$to]) {
        push @{$self->{queue}}, $to;
        $self->{on_queue}[$to] = 1;
      }
    }
    if (($self->{cycles} != 0) && ($self->{cycles} % $graph->V) == 0) {
      $self->_find_negative_cycle;
    }
    $self->{cycles}++;
  }
}

sub _find_negative_cycle {
  my $self = shift;
  my $graph = $self->{graph};
  my $v = $graph->V;

  my $shortest = DIGraph->new($v);
  for (my $i = 0; $i < $v; $i++) {
    if ($self->{edge_to}[$i]) {
       $shortest->add_edge($self->{edge_to}[$i]);
    }
  }

  my $cycle_finder = Cycle->new($shortest);
  $self->{cycle} = $cycle_finder->find;
}

1;

