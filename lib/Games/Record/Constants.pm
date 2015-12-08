package Games::Record::Constants;

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

our $VERSION = '2015120801';

use Exporter ();

our @ISA    = qw [Exporter];
our @EXPORT = qw [$GAME_IN_PROGRESS 
                  $GAME_DECIDED
                  $GAME_DRAWN
                  $GAME_RESIGNED
                  $GAME_TIMED_OUT
                  $GAME_DRAW_AGREED
                  $GAME_TECHNICAL_DRAW];


#
# Reasons why a game was finished
#
our $GAME_IN_PROGRESS       =  0;   # Not finished.
our $GAME_DECIDED           =  1;   # A deciding move was played.
our $GAME_DRAWN             =  2;   # No move left, or other position which
                                    # is a draw.
our $GAME_RESIGNED          =  3;   # A player resigned.
our $GAME_TIMED_OUT         =  4;   # Game timed out.
our $GAME_DRAW_AGREED       =  5;   # Players agreed to draw.
our $GAME_TECHNICAL_DRAW    =  6;   # Mechanism to prevent the game carrying on.


1;

__END__

=pod
