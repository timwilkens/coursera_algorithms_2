package Paths;

use strict;
use warnings;
use UDGraph;

sub new {
  my ($class, $graph, $vertex) = @_;

  my %self;
  $self{graph} = $graph;
  $self{s} = $vertex;
  $self{marked} = [];
  $self{edge_to} = [];

  return bless \%self, $class;
}

sub has_path_to { 
  my ($self, $v) = @_;
  return $self->{marked}[$v];
}

sub path_to {
  my ($self, $v) = @_;

  if (not defined $self->has_path_to($v)) { 
    return undef;
  }

  my @path;

  for (my $x = $v; $x != $self->{s}; $x = $self->{edge_to}[$x]){
    push @path, $x;
  }

  push @path, $self->{s};
  return @path;
}

sub depth_first {
  my $self = shift;
  $self->_dfs($self->{s});
}

sub _dfs {
  my ($self, $v) = @_;
  my $graph = $self->{graph};
  my $marked = $self->{marked};
  my $edge_to = $self->{edge_to};

  $marked->[$v] = 1;

  for my $w ($graph->adj($v)) {
    if (!$marked->[$w]) {
      $self->_dfs($w);
      $edge_to->[$w] = $v;
    }
  }
}

1;

