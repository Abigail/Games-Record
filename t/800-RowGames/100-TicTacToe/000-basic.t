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

ok defined $Games::Record::RowGames::TicTacToe::VERSION, "VERSION is set";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
