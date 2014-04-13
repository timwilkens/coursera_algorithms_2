#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use Data::Dumper;
use DIGraph;
use BellFord;

my $data = get_and_parse_content();
my %currency_map;
my @index_map;
my %rates;
my $mapper = currency_to_index();

my $graph = make_graph($data);

find_opportunity($graph);

sub find_opportunity {
  my $graph = shift;
  my $searcher = BellFord->new($graph, 0);
  $searcher->bellman_ford;

  if ($searcher->has_cycle) {

    my @cycle = $searcher->get_cycle;
    my $dollars = 1000;
    print "Starting with $dollars\n";
    for (my $from = scalar(@cycle) - 2; $from >= 0; $from--) {
      my $to = $from + 1;
      my $rate_key = join('', $cycle[$from],'_',$cycle[$to]);
      my $rate = $rates{$rate_key};
      $dollars *= $rate;
  
      my $to_name = $index_map[$cycle[$to]];
      my $from_name = $index_map[$cycle[$from]];
  
      print "$to_name => $from_name : $rate  : $dollars\n";
    }
    print "End with $dollars\n";

  } else {
    print "No opportunity available\n";
  }

}

sub make_graph {
  my $data = shift;
  my $graph = DIGraph->new(16);

  while (my ($conversion, $stats) = each %{$data->{results}{rate}}) {
    my $from;
    my $to;
    if ($conversion =~ /^([A-Z]{3})([A-Z]{3})$/) {
      $from = $1;
      $to = $2;
    } else {
      die "Malformed conversion key '$conversion'";
    }
  
    $from = $mapper->($from);
    $to = $mapper->($to);
  
    my $rate = $stats->{Rate};
    my $rate_key = join('', $from,'_',$to);
    $rates{$rate_key} = $rate;
  
    $graph->add_edge($from, $to, -log($rate));
  }
  return $graph;
}

sub currency_to_index {
  my $index = 0;

  sub {
    my $currency = shift;
    if (exists $currency_map{$currency}) {
      $currency_map{$currency};
    } else {
      $currency_map{$currency} = $index;
      $index_map[$index] = $currency;
      $index++;
      return ($index - 1);
    }
  }
}

sub get_and_parse_content {

  my $url = 'http://query.yahooapis.com/v1/public/yql?q=select%20%2a%20from%20yahoo.finance.xchange%20where%20pair%20in%20%28';
  my $end = '%29&env=store://datatables.org/alltableswithkeys';

#  my @currencies = qw( USD EUR JPY BGN CZK DKK GBP HUF LTL LVL PLN RON SEK CHF NOK HRK RUB TRY AUD BRL CAD CNY HKD IDR ILS INR KRW
#                       MXN MYR NZD PHP SGD THB ZAR ISK );

  my @currencies = qw( USD EUR JPY BGN CZK DKK GBP HUF LTL LVL PLN RON SEK CHF NOK HRK );

  for my $from (@currencies) {
    for my $to (@currencies) {
      next if $from eq $to;

      $url .= "%22$from$to%22,%20";
    }
  }

  $url =~ s/,%20$//;
  $url .= $end;

  my $ua = LWP::UserAgent->new;
  my $res = $ua->get($url);
  die "Could not get content at '$url'" if ($res->code != 200);

  my $parser = XML::Simple->new;
  return $parser->XMLin($res->content);
}
