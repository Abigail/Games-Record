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


my $game1 = Games::Record:: -> new -> init;
my $game2 = Games::Record:: -> new -> init;

is $game1 -> _game_finished, $GAME_IN_PROGRESS, "Game 1 not finished";
is $game2 -> _game_finished, $GAME_IN_PROGRESS, "Game 2 not finished";

$game1 -> _set_game_finished (state => $GAME_DECIDED);
$game2 -> _set_game_finished (state => $GAME_DRAW_AGREED);

is $game1 -> _game_finished, $GAME_DECIDED,     "Game 1 decided";
is $game2 -> _game_finished, $GAME_DRAW_AGREED, "Game 2 draw agreed";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
