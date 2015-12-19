#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;
use List::Util 'min';

our $r = eval "require Test::NoWarnings; 1";

BEGIN {
    use_ok ('Games::Record') or
        BAIL_OUT ("Loading of 'Games::Record' failed");
    use_ok ('Games::Record::Constants', ':ALL') or
        BAIL_OUT ("Loading of 'Games::Record::Constants' failed");
}

my $X_SIZE = 3;
my $Y_SIZE = 4;


my $game2 = Games::Record:: -> new -> init (nr_of_players => 2);
my $game3 = Games::Record:: -> new -> init (nr_of_players => 3);
my $game4 = Games::Record:: -> new -> init (nr_of_players => 4);

is $game2 -> _current_player, 0, "Player 0 goes first in two player game";
is $game3 -> _current_player, 0, "Player 0 goes first in three player game";
is $game4 -> _current_player, 0, "Player 0 goes first in four player game";

$_ -> _inc_current_player for $game2, $game3, $game4;
is $game2 -> _current_player, 1, "Player 1 is next in two player game";
is $game3 -> _current_player, 1, "Player 1 is next in three player game";
is $game4 -> _current_player, 1, "Player 1 is next in four player game";

$_ -> _inc_current_player for $game2, $game3, $game4;
is $game2 -> _current_player, 0, "Player 0 is next in two player game";
is $game3 -> _current_player, 2, "Player 2 is next in three player game";
is $game4 -> _current_player, 2, "Player 2 is next in four player game";

$_ -> _inc_current_player for $game2, $game3, $game4;
is $game2 -> _current_player, 1, "Player 1 is next in two player game";
is $game3 -> _current_player, 0, "Player 0 is next in three player game";
is $game4 -> _current_player, 3, "Player 3 is next in four player game";

$_ -> _inc_current_player for $game2, $game3, $game4;
is $game2 -> _current_player, 0, "Player 0 is next in two player game";
is $game3 -> _current_player, 1, "Player 1 is next in three player game";
is $game4 -> _current_player, 0, "Player 0 is next in four player game";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
