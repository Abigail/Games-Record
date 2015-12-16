#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

use Games::Record::Constants qw [:MOVE_TYPES];


my $i = 0;
is $MOVE_TYPE_DROP,    $i ++, '$MOVE_TYPE_DROP';
is $MOVE_TYPE_MOVE,    $i ++, '$MOVE_TYPE_MOVE';
is $MOVE_TYPE_TAKE,    $i ++, '$MOVE_TYPE_TAKE';
is $MOVE_TYPE_MAX,     $i ++, '$MOVE_TYPE_MAX';


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
