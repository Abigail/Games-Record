#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

use Games::Record::Constants qw [:GAME_STATE];


my $i = 0;
is $GAME_IN_PROGRESS,    $i ++, '$GAME_IN_PROGRESS';
is $GAME_DECIDED,        $i ++, '$GAME_DECIDED';
is $GAME_DRAWN,          $i ++, '$GAME_DRAWN';
is $GAME_RESIGNED,       $i ++, '$GAME_RESIGNED';
is $GAME_TIMED_OUT,      $i ++, '$GAME_TIMED_OUT';
is $GAME_DRAW_AGREED,    $i ++, '$GAME_DRAW_AGREED';
is $GAME_TECHNICAL_DRAW, $i ++, '$GAME_TECHNICAL_DRAW';
is $GAME_STATE_MAX,      $i ++, '$GAME_STATE_MAX';


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
