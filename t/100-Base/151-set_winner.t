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
    use_ok ('Games::Record::Constants') or
        BAIL_OUT ("Loading of 'Games::Record::Constants' failed");
}


my $game1 = Games::Record:: -> new -> init (nr_of_players => 3);
my $game2 = Games::Record:: -> new -> init (nr_of_players => 5);

ok !defined $game1 -> _winner, "Game 1 does not have a winner yet";
ok !defined $game2 -> _winner, "Game 2 does not have a winner yet";

$game1 -> _set_winner (winner => 0);
$game2 -> _set_winner (winner => 2);

is $game1 -> _winner, 0, "Game 1 has no winner";
is $game2 -> _winner, 2, "Game 2 has winner";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
