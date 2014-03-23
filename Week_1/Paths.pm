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
  $self{id} = [];
  $self{group} = [];
  $self{bi} = undef;
  $self{count} = undef;

  return bless \%self, $class;
}

sub clean {
  my $self = shift;

  $self->{marked} = [];
  $self->{edge_to} = [];
  $self->{id} = [];
  $self->{group} = [];
  $self->{bi} = undef;
  $self->{count} = undef;
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

sub breadth_first {
  my $self = shift;
  $self->clean;  # Auto-clean

  my $s = $self->{s};
  my $marked = $self->{marked};
  my $edge_to = $self->{edge_to};
  my $graph = $self->{graph};
  my @queue;

  
  push @queue, $s;
  $marked->[$s] = 1;

  while (@queue) {
    my $v = shift @queue;
    for my $w ($graph->adj($v)) {
      if (!$marked->[$w]) {
        push @queue, $w;
        $marked->[$w] = 1;
        $edge_to->[$w] = $v
      }
    }
  }
}

sub depth_first {
  my $self = shift;
  $self->clean;  # Auto-clean

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

sub connected_components {
  my $self = shift;
  $self->clean;  # Auto-clean

  my $graph = $self->{graph};
  my $marked = $self->{marked};
  my $num_of_vertices = $graph->{V};
  my $count = 0;


  for (my $v = 0; $v < $num_of_vertices; $v++) {
    if (!$marked->[$v]) {
      $self->_cc_dfs($v, $count);
      $count++;
    }
  }
  
  $self->{count} = $count;
}

sub _cc_dfs {
  my ($self, $v, $count) = @_;
  my $graph = $self->{graph};
  my $marked = $self->{marked};
  my $edge_to = $self->{edge_to};
  my $id = $self->{id};

  $marked->[$v] = 1;
  $id->[$v] = $count;

  for my $w ($graph->adj($v)) {
    if (!$marked->[$w]) {
      $self->_cc_dfs($w, $count);
      $edge_to->[$w] = $v;
    }
  }
}

sub count { return shift->{count}; }

sub id { return $_[0]->{id}[$_[1]]; }

sub in_connected_component {
  my ($self, $v, $w) = @_;

  if ($self->id($v) == $self->id($w)) {
    return 1;
  } else {
    return 0;
  }
}

sub is_bipartite {
  my $self = shift;
  $self->clean;  # Auto-clean

  my $s = $self->{s};
  $self->{bi} = 1; # Initialize to true.

  $self->_bi_dfs($s, 0); # Initial group is 0. 

  return $self->{bi};
}

sub _bi_dfs {
  my ($self, $v, $g) = @_;
  my $graph = $self->{graph};
  my $marked = $self->{marked};
  my $edge_to = $self->{edge_to};
  my $group = $self->{group};

  $marked->[$v] = 1;
  $group->[$v] = $g;

  for my $w ($graph->adj($v)) {
    if (!$marked->[$w]) {
      $self->_bi_dfs($w, (($g + 1) % 2));
      $edge_to->[$w] = $v;
    } elsif ($group->[$w] == $g) {
      $self->{bi} = 0; # Not bipartite.
    }
  }
}

1;

