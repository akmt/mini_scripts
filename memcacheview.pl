#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use Data::Dumper;
use Cache::Memcached;

sub p { print Dumper shift; }

my $server = $ARGV[0] || "localhost";
my $port   = $ARGV[1] || "11211";
my $s      = "$server:$port";

say "=========================";
say " Memcache Viewer ";
say " from $s";
say "=========================";

my $m = new Cache::Memcached( { servers => [$s] } );
my $res = $m->stats("items");
if ( $res->{hosts} ) {
    my $i = $res->{hosts}{$s}{items};
    my @a = split( "\n", $i );

    my %cache_list;
    while (<@a>) {
        if ( $_ =~ /items:([0-9]+)/ ) {
            $cache_list{$1} = $_;
        }
    }

    foreach my $key ( keys %cache_list ) {
        my $cm  = "cachedump $key 100";
        my $res = $m->stats($cm);
        my $rec = $res->{hosts}{$s}{$cm};

        if ( $rec =~ /ITEM\s(\S+)\s/ ) {
            my $res = $m->get($1);
            say "--- \n" . "KEY : $1";
            say "DATA: " . $res;
        }

    }

}
else {
    say("unknown memcache host error.");
}
exit(0);
