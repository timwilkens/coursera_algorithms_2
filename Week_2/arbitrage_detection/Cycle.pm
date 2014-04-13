package Cycle;

use strict;
use warnings;
use DIGraph;

sub new {
  my ($class, $graph) = @_;

  my %self;

  $self{graph} = $graph;
  $self{marked} = [];
  $self{edge_to} = [];
  $self{on_stack} = [];
  $self{cycle} = undef;

  bless \%self, $class;
}

sub find {
  my $self = shift;

  $self->_find_cycle;
  return $self->{cycle};
}


sub _find_cycle {
  my $self = shift;

  my $graph = $self->{graph};
  my $marked = $self->{marked};
  my $num_of_vertices = $graph->V;


  for (my $v = 0; $v < $num_of_vertices; $v++) {
    if (!$marked->[$v]) {
      $self->_cycle_dfs($v);
    }
  }

  return $self->{cycle} ? 1 : 0;
}

sub _cycle_dfs {
  my ($self, $v) = @_;
  my $graph = $self->{graph};
  my $marked = $self->{marked};
  my $edge_to = $self->{edge_to};
  my $on_stack = $self->{on_stack};

  $on_stack->[$v] = 1;
  $marked->[$v] = 1;

  for my $edge ($graph->adj($v)) {
    my $w = $edge->to;
    if ($self->{cycle}) {
      return;
    } elsif (!$marked->[$w]) {
      $edge_to->[$w] = $v;
      $self->_cycle_dfs($w);
    } elsif ($on_stack->[$w]) {
      my @cycle;
      for (my $x = $v; $x != $w; $x = $edge_to->[$x]) {
        push @cycle, $x;
      }
      push @cycle, $w;
      push @cycle, $v;
      @cycle = reverse(@cycle);
      $self->{cycle} = \@cycle;
    }
  }
 $on_stack->[$v] = undef;
}

1;

