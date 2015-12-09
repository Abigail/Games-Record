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
    use_ok ('Games::Record::Constants') or
        BAIL_OUT ("Loading of 'Games::Record::Constants' failed");
}


my $ttt = Games::Record::RowGames::TicTacToe:: -> new -> init;

is $ttt -> check_finished, $GAME_IN_PROGRESS, "Empty board means in progress";

#
# Place some pieces; don't make 3 in a row
#
$ttt -> _place (x => 0, y => 0, piece => 1);
$ttt -> _place (x => 1, y => 0, piece => 1);
$ttt -> _place (x => 2, y => 0, piece => 2);
is $ttt -> check_finished, $GAME_IN_PROGRESS, "Not all the same in a row";

#
# Another naught, still no finish
#
$ttt -> _place (x => 1, y => 1, piece => 2);
is $ttt -> check_finished, $GAME_IN_PROGRESS, "Not a win yet";

#
# Another cross, still no finish
#
$ttt -> _place (x => 0, y => 1, piece => 1);
is $ttt -> check_finished, $GAME_IN_PROGRESS, "Still no win";

#
# Win on the diagonal
#
$ttt -> _place (x => 0, y => 2, piece => 2);
is $ttt -> check_finished, $GAME_DECIDED, "Win on diagonal";
is $ttt -> _winner, 2, "Player 2 wins!";


#
# New board, win on a vertical.
#
$ttt = Games::Record::RowGames::TicTacToe:: -> new -> init;
$ttt -> _place (x => 1, y => 0, piece => 1);
$ttt -> _place (x => 1, y => 1, piece => 1);
$ttt -> _place (x => 1, y => 2, piece => 1);
$ttt -> _place (x => 0, y => 2, piece => 2);
$ttt -> _place (x => 2, y => 1, piece => 2);
is $ttt -> check_finished, $GAME_DECIDED, "Win on vertical";
is $ttt -> _winner, 1, "Player 1 wins!";

#
# New board, win on a horizontal.
#
$ttt = Games::Record::RowGames::TicTacToe:: -> new -> init;
$ttt -> _place (x => 0, y => 2, piece => 1);
$ttt -> _place (x => 1, y => 2, piece => 1);
$ttt -> _place (x => 2, y => 2, piece => 1);
$ttt -> _place (x => 0, y => 1, piece => 2);
$ttt -> _place (x => 2, y => 1, piece => 2);
is $ttt -> check_finished, $GAME_DECIDED, "Win on horizontal";
is $ttt -> _winner, 1, "Player 1 wins!";

#
# New board, win on a diagonal.
#
$ttt = Games::Record::RowGames::TicTacToe:: -> new -> init;
$ttt -> _place (x => 0, y => 0, piece => 1);
$ttt -> _place (x => 1, y => 1, piece => 1);
$ttt -> _place (x => 2, y => 2, piece => 1);
$ttt -> _place (x => 0, y => 1, piece => 2);
$ttt -> _place (x => 2, y => 1, piece => 2);
is $ttt -> check_finished, $GAME_DECIDED, "Win on diagonal";
is $ttt -> _winner, 1, "Player 1 wins!";


#
# New board, win on other diagonal.
#
$ttt = Games::Record::RowGames::TicTacToe:: -> new -> init;
$ttt -> _place (x => 0, y => 2, piece => 2);
$ttt -> _place (x => 1, y => 1, piece => 2);
$ttt -> _place (x => 2, y => 0, piece => 2);
$ttt -> _place (x => 0, y => 1, piece => 1);
$ttt -> _place (x => 2, y => 1, piece => 1);
$ttt -> _place (x => 0, y => 0, piece => 1);
is $ttt -> check_finished, $GAME_DECIDED, "Win on other diagonal";
is $ttt -> _winner, 2, "Player 2 wins!";


#
# New board, fill board, no 3-in-a-row
#
$ttt = Games::Record::RowGames::TicTacToe:: -> new -> init;
$ttt -> _place (x => 0, y => 0, piece => 1);
$ttt -> _place (x => 1, y => 1, piece => 2);
$ttt -> _place (x => 2, y => 2, piece => 1);
$ttt -> _place (x => 0, y => 1, piece => 2);
$ttt -> _place (x => 2, y => 1, piece => 1);
$ttt -> _place (x => 2, y => 0, piece => 2);
$ttt -> _place (x => 0, y => 2, piece => 1);
$ttt -> _place (x => 1, y => 2, piece => 2);
$ttt -> _place (x => 1, y => 0, piece => 1);
is $ttt -> check_finished, $GAME_DRAWN, "Game is a draw";
is $ttt -> _winner, 0, "Game finished, no winner";



Test::NoWarnings::had_no_warnings () if $r;

done_testing;
