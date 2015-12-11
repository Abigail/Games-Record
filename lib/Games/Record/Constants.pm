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
                  $GAME_TECHNICAL_DRAW
                  $GAME_STATE_MAX
];


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

our $GAME_STATE_MAX         =  6;   # Up when there are more states.


my %sets = (
    #
    # Reasons a move cannot be played
    #
    MOVE_FAILURES  => [qw [
        FAILED_TO_PARSE_MOVE
        GAME_FINISHED
        DROP_FIELD_DOES_NOT_EXIST
        SOURCE_FIELD_DOES_NOT_EXIST
        TARGET_FIELD_DOES_NOT_EXIST
        NOT_PLAYERS_TURN
    ]],
);
foreach my $set (values %sets) {
    for (my $i = 0; $i < @$set; $i ++) {
        my $name = $$set [$i];
        no strict 'refs';
        ${__PACKAGE__ . "::${name}"} = $i + 1;
        push @EXPORT => "\$${name}";
    }
}


1;

__END__

=pod
