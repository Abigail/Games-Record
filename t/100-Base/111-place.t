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

my $record = Games::Record:: -> new -> init (
    x_size       =>  7,
    y_size       =>  6,
    nr_of_pieces =>  4,
);

my $board_res;
my $board_exp;

$board_res = $record -> _board;
$board_exp = [[0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0]];
is_deeply $board_res, $board_exp, "Created board";
is $record -> _x_size, 7, "Board, X direction";
is $record -> _y_size, 6, "Board, Y direction";

#
# Place some pieces
#
$record -> _place (x => 1, y => 3, piece => 1);
$record -> _place (x => 3, y => 2, piece => 2);
$record -> _place (x => 6, y => 5, piece => 3);
$record -> _place (x => 0, y => 0, piece => 4);
$board_res = $record -> _board;
$$board_exp [1] [3] = 1;
$$board_exp [3] [2] = 2;
$$board_exp [6] [5] = 3;
$$board_exp [0] [0] = 4;
is_deeply $board_res, $board_exp, "Placed pieces on board";

#
# Check whether we can clear some fields
#
$record -> _place (x => 3, y => 2, piece => 0);
$record -> _place (x => 6, y => 5, piece => 0);
$board_res = $record -> _board;
$$board_exp [3] [2] = 0;
$$board_exp [6] [5] = 0;
is_deeply $board_res, $board_exp, "Clearing fields";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
