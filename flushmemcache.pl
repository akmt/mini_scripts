#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use Data::Dumper;
use Cache::Memcached;

sub p { print Dumper shift; }

sub clear_memcache {

    my $server = $ARGV[0] || "192.168.0.1";
    my $port   = $ARGV[1] || "11211";
    my $s      = "$server:$port";

    say "=========================";
    say " Memcached Server ";
    say " $s";
    say "=========================";

    my $m = new Cache::Memcached( { servers => [$s] } );
    if ( $m->flush_all() ) {
        say "memcache flush_all done.";
    } else {
        say "error!";
    }

}

clear_memcache();

exit(0);
