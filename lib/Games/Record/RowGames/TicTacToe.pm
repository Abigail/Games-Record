package Games::Record::RowGames::TicTacToe;

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Hash::Util::FieldHash qw [fieldhash];

use Games::Record::Constants;
use Games::Record::RowGames;

our @ISA = qw [Games::Record::RowGames];
our $VERSION = $Games::Record::VERSION;

fieldhash my %board;

my $X_SIZE = 3;
my $Y_SIZE = 3;

sub init {
    my $self  = shift;
    $self -> SUPER::init (x_size => $X_SIZE,
                          y_size => $Y_SIZE,
                          @_);
    $self;
}


#
# Calculate whether a game is finished.
#
sub check_finished {
    my $self  = shift;
    my $state = $self -> _game_finished;
    return $state if $state != $GAME_IN_PROGRESS;
    my $winning_piece;

  CHECK: {
       #
       # Horizontal row?
       #
      ROW:
        for (my $y = 0; $y < $self -> _y_size; $y ++) {
            my $piece0 = $self -> _piece (x => 0, y => $y);
            next ROW unless $piece0;
            for (my $x = 1; $x < $self -> _x_size; $x ++) {
                my $piece = $self -> _piece (x => $x, y => $y);
                next ROW unless $piece0 == $piece;
            }
            $state = $GAME_DECIDED;
            $winning_piece = $piece0;
            last CHECK;
        }
        #
        # Vertical row?
        #
      COLUMN:
        for (my $x = 0; $x < $self -> _x_size; $x ++) {
            my $piece0 = $self -> _piece (x => $x, y => 0);
            next COLUMN unless $piece0;
            for (my $y = 1; $y < $self -> _y_size; $y ++) {
                my $piece = $self -> _piece (x => $x, y => $y);
                next COLUMN unless $piece0 == $piece;
            }
            $state = $GAME_DECIDED;
            $winning_piece = $piece0;
            last CHECK;
        }
        #
        # Diagonal row?
        #
      DIAGONAL_XY: {
            my $piece0 = $self -> _piece (x => 0, y => 0);
            next DIAGONAL_XY unless $piece0;
            for (my $d = 1; $d < $self -> _x_size; $d ++) {
                my $piece = $self -> _piece (x => $d, y => $d);
                next DIAGONAL_XY unless $piece0 == $piece;
            }
            $state = $GAME_DECIDED;
            $winning_piece = $piece0;
            last CHECK;
        }
      DIAGONAL_YX: {
            my $y = $self -> _y_size - 1;
            my $x = 0;
            my $piece0 = $self -> _piece (x => $x, y => $y);
            next DIAGONAL_YX unless $piece0;
            for (my $d = 1; $d < $self -> _x_size; $d ++) {
                $x ++;
                $y --;
                my $piece = $self -> _piece (x => $x, y => $y);
                next DIAGONAL_XY unless $piece0 == $piece;
            }
            $state = $GAME_DECIDED;
            $winning_piece = $piece0;
            last CHECK;
        }
    }

    if ($state == $GAME_DECIDED) {
        $self -> _set_game_finished (state => $GAME_DECIDED);
        #
        # Piece player uses has the same index
        #
        $self -> _set_winner ($winning_piece);

        return $GAME_DECIDED;
    }

    #
    # Game may be a draw
    #
    for (my $x = 0; $x < $self -> _x_size; $x ++) {
        for (my $y = 0; $y < $self -> _y_size; $y ++) {
            my $piece = $self -> _piece (x => $x, y => $y);
            return $GAME_IN_PROGRESS if $piece;
        }
    }

    $self -> _set_game_finished (state => $GAME_DRAWN);
    $self -> _set_winner (0);
    return $GAME_DRAWN;
}



__END__

=pod
