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

{
    no warnings 'redefine';
    sub Games::Record::_allow_drops {
        return 1;
    }
}

my $X_SIZE = 3;
my $Y_SIZE = 4;

my $game = Games::Record:: -> new -> init (x_size       => $X_SIZE,
                                           y_size       => $Y_SIZE,
                                           nr_of_pieces => 1);

#
# Drops on empty fields are fine.
#
for (my $x = 0; $x < $X_SIZE; $x ++) {
    for (my $y = 0; $y < $Y_SIZE; $y ++) {
        my $res = $game -> _may_drop_piece_on (x => $x, y => $y);
        ok $res, "May drop ($x, $y) on empty board";
    }
}

#
# Place some pieces.
#
for (my $z = 0; $z < min ($X_SIZE, $Y_SIZE); $z ++) {
    $game -> _place (x => $z, y => $z, piece => 1);
}
#
# Cannot drop on occupied fields, but dropping on other
# fields should be fine.
#
for (my $x = 0; $x < $X_SIZE; $x ++) {
    for (my $y = 0; $y < $Y_SIZE; $y ++) {
        $game -> _set_error (error => undef);
        my $res = $game -> _may_drop_piece_on (x => $x, y => $y);
        if ($x == $y) {
            ok !$res, "May not drop on occupied field ($x, $y)";
            is  $game -> error, $MOVE_ERROR_FIELD_OCCUPIED,
                                "Error 'Field occupied' was set";
        }
        else {
            ok $res, "May drop on empty field ($x, $y) of partial filled board";
        }
    }
}

#
# Fill the board.   
#
for (my $x = 0; $x < $X_SIZE; $x ++) {
    for (my $y = 0; $y < $Y_SIZE; $y ++) {
        $game -> _place (x => $x, y => $y, piece => 1);
    }
}

#
# Should not be able to place anything on the board.
#
for (my $x = 0; $x < $X_SIZE; $x ++) {
    for (my $y = 0; $y < $Y_SIZE; $y ++) {
        $game -> _set_error (error => undef);
        my $res = $game -> _may_drop_piece_on (x => $x, y => $y);
        ok !$res, "May not drop ($x, $y) on filled board";
        is  $game -> error, $MOVE_ERROR_FIELD_OCCUPIED,
                            "Error 'Field occupied' was set";
    }
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
