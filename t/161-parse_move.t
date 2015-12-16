#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

BEGIN {
    use_ok ('Games::Record') or
        BAIL_OUT ("Loading of 'Games::Record' failed");
    use_ok ('Games::Record::Constants', ':ALL') or
        BAIL_OUT ("Loading of 'Games::Record::Constants' failed");
}


my $game = Games::Record:: -> new -> init;

my @files  = ('a' .. 'z');

for (my $x = 0; $x < @files; $x ++) {
    for (my $y = 0; $y < @files; $y ++) {
        my $field = sprintf "%s%d" => $files [$x], $y + 1;
        my $res   = $game -> _parse_move (move => $field);

        is_deeply $res, [$MOVE_TYPE_DROP => [$x, $y]], "Drop on $field";
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
