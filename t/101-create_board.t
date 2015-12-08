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
}

my $record = Games::Record:: -> new -> init;

my $board_res;
my $board_exp;

#
# Create a minimal board.
#
$record -> _create_board (x_size => 1, y_size => 1);
$board_res = $record -> _board;
$board_exp = [[0]];
is_deeply $board_res, $board_exp, "Minimal board";
is $record -> _x_size, 1, "Minimal board, X direction";
is $record -> _y_size, 1, "Minimal board, Y direction";

#
# Try a larger one, which isn't a square
#
$record -> _create_board (x_size => 5, y_size => 7);
$board_res = $record -> _board;
$board_exp = [[0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0]];
is_deeply $board_res, $board_exp, "Non-square board";
is $record -> _x_size, 5, "Non-square board, X direction";
is $record -> _y_size, 7, "Non-square board, Y direction";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
