#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

use Games::Record::Constants qw [:MOVE_ERRORS];


my $i = 0;
is $MOVE_ERROR_MOVE_ACCEPTED,        $i ++, '$MOVE_ERROR_MOVE_ACCEPTED';
is $MOVE_ERROR_FAILED_TO_PARSE,      $i ++, '$MOVE_ERROR_FAILED_TO_PARSE';
is $MOVE_ERROR_GAME_FINISHED,        $i ++, '$MOVE_ERROR_GAME_FINISHED';
is $MOVE_ERROR_FIELD_DOES_NOT_EXIST, $i ++, '$MOVE_ERROR_FIELD_DOES_NOT_EXIST';
is $MOVE_ERROR_NOT_PLAYERS_TURN,     $i ++, '$MOVE_ERROR_NOT_PLAYERS_TURN';
is $MOVE_ERROR_GAME_DOES_NOT_ALLOW_DROPS,
                                     $i ++, '$MOVE_ERROR_GAME_DOES_NOT_' .
                                                  'ALLOW_DROPS';
is $MOVE_ERROR_MAX,                  $i ++, '$MOVE_ERROR_MAX';


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
