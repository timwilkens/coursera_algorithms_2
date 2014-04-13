package Edge;

use strict;
use warnings;

sub new {
  my ($class, $from, $to, $weight) = @_;

  my %self;
  $self{from} = $from;
  $self{to} = $to;
  $self{weight} = $weight;

  bless \%self, $class;

}

sub from { return shift->{from} }
sub to { return shift->{to} }
sub weight{ return shift->{weight} }

1;
