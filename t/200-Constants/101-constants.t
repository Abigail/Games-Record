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

ok defined $Games::Record::Constants::VERSION, "VERSION is set";

ok defined $Games::Record::Constants::GAME_IN_PROGRESS,
                                     "GAME_IN_PROGRESS is set";
ok defined $Games::Record::Constants::GAME_DECIDED,
                                     "GAME_DECIDED is set";
ok defined $Games::Record::Constants::GAME_RESIGNED,
                                     "GAME_RESIGNED is set";
ok defined $Games::Record::Constants::GAME_TIMED_OUT,
                                     "GAME_TIMED_OUT is set";
ok defined $Games::Record::Constants::GAME_DRAW_AGREED,
                                     "GAME_DRAW_AGREED is set";
ok defined $Games::Record::Constants::GAME_TECHNICAL_DRAW,
                                     "GAME_TECHNICAL_DRAW is set";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
