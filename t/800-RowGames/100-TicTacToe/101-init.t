#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

BEGIN {
    use_ok ('Games::Record::RowGames::TicTacToe') or
        BAIL_OUT ("Loading of 'Games::Record::RowGames::TicTacToe' failed");
}

my $tictactoe = Games::Record::RowGames::TicTacToe:: -> new -> init;

#
# Check board size
#
is $tictactoe -> _x_size, 3, "Board size in the X dimension";
is $tictactoe -> _y_size, 3, "Board size in the Y dimension";
my $board_exp = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
is_deeply $tictactoe -> _board, $board_exp, "Initial board";

#
# Check number of players, and current player
#
is $tictactoe -> _nr_of_players,  2, "Number of players";
is $tictactoe -> _current_player, 1, "Current player";

#
# Check number of pieces
#
is $tictactoe -> _nr_of_pieces, 2, "Number of pieces";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
