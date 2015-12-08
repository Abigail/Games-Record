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

my $record = Games::Record:: -> new -> init (
    x_size         =>  3,
    y_size         =>  5,
    nr_of_pieces   =>  4,
    nr_of_players  =>  3,
    current_player =>  1, 
);

my $board_res;
my $board_exp;

$board_res = $record -> _board;
$board_exp = [[0, 0, 0],
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0],
              [0, 0, 0]];
is_deeply $board_res, $board_exp, "Created board";
is $record -> _x_size, 3, "Board, X direction";
is $record -> _y_size, 5, "Board, Y direction";


is $record -> _nr_of_players,  3, "Nr of players set";
is $record -> _current_player, 1, "Current player set";
is $record -> _nr_of_pieces,   4, "Nr of pieces";

is $record -> _game_finished, $GAME_IN_PROGRESS, "Game in progress";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
