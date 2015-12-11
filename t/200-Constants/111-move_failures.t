#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

BEGIN {
    use_ok ('Games::Record::Constants') or
        BAIL_OUT ("Loading of 'Games::Record::Constants' failed");
}


ok defined $FAILED_TO_PARSE_MOVE,         '$FAILED_TO_PARSE_MOVE';
ok defined $GAME_FINISHED,                '$GAME_FINISHED';
ok defined $DROP_FIELD_DOES_NOT_EXIST,    '$DROP_FIELD_DOES_NOT_EXIST';
ok defined $SOURCE_FIELD_DOES_NOT_EXIST,  '$SOURCE_FIELD_DOES_NOT_EXIST';
ok defined $TARGET_FIELD_DOES_NOT_EXIST,  '$TARGET_FIELD_DOES_NOT_EXIST';
ok defined $NOT_PLAYERS_TURN,             '$NOT_PLAYERS_TURN';


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
