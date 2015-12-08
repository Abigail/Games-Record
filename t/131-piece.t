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
    use_ok ('Games::Record::Constants') or
        BAIL_OUT ("Loading of 'Games::Record::Constants' failed");
}

#
# Create an empty board
#
my $record = Games::Record:: -> new -> init (
    x_size         =>  3,
    y_size         =>  5,
    nr_of_pieces   =>  4,
);

#
# Place some pieces
#
$record -> _place (x => 0, y => 0, piece => 1);
for (my $x = 0; $x < 3; $x ++) {
    $record -> _place (x => $x, y => 1, piece => 2);
}

#
# Read back values
#
is $record -> _piece (x => 0, y => 2), 0, "Nothing placed";
is $record -> _piece (x => 0, y => 0), 1, "Found piece (0, 0)";
is $record -> _piece (x => 2, y => 1), 2, "Found piece (2, 1)";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
