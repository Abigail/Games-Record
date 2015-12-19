package Games::Record;

use 5.010;
use strict;
use warnings;
no  warnings 'syntax';

use Hash::Util::FieldHash qw [fieldhash];
use Games::Record::Constants qw [:ALL];

our $VERSION = '2015120801';

fieldhash my %board;
fieldhash my %x_size;
fieldhash my %y_size;
fieldhash my %nr_of_players;
fieldhash my %current_player;
fieldhash my %nr_of_pieces;
fieldhash my %game_finished;   # False when progress, reason when finished.
fieldhash my %winner;          # Winner of the game (undef: game in progress,
                               #                     0: draw)
fieldhash my %error;

my $DEFAULT_NR_OF_PLAYERS  = 2;
my $DEFAULT_CURRENT_PLAYER = 1;


sub new  {bless \do {my $var} => shift};

# -----------------------------------------------------------------------------
# init
#
# Initialize the object. This is typically called by a SUPER:: from a
# derived class. 
#
# Parameters:
#    - x_size, y_size:  If both are given, create an empty board with
#                       these dimensions. 
#    - nr_of_players:   Set the number of players (default: 2).
#    - current_player:  Set the current player, (default: 0).
#    - nr_of_pieces:    Set the number of the game uses.
#
sub init {
    my ($self, %args) = @_;

    if ($args {x_size} && $args {y_size}) {
        $self -> _create_board (x_size => $args {x_size},
                                y_size => $args {y_size});
    }

    $nr_of_players  {$self} = $args {nr_of_players}  // $DEFAULT_NR_OF_PLAYERS;
    $current_player {$self} = $args {current_player} // $DEFAULT_CURRENT_PLAYER;
    $nr_of_pieces   {$self} = $args {nr_of_pieces} if
                              $args {nr_of_pieces};
    $game_finished  {$self} = $GAME_IN_PROGRESS;
    $self;
}


# -----------------------------------------------------------------------------
# _create_board
#
# Internal method which creates an empty board, and stores it.
# The fields are initialized to 0.
#
# Parameters:
#      x_size:   Size of board in X dimension.
#      y_size:   Size of board in Y dimension.
# 
sub _create_board {
    my ($self, %args) = @_;

    my $board;
    push @$board => [(0) x $args {y_size}] for 1 .. $args {x_size};

    $board {$self}  = $board;
    $x_size {$self} = $args {x_size};
    $y_size {$self} = $args {y_size};
    $self;
}

# -----------------------------------------------------------------------------
# _place
#
# Place a piece of on the board, on given coordinates.
# Note, this places the piece unconditionally; this is *not* the
# same as doing a move. No validation, or after effects will happen.
# Placing a 0 means clearing the field.
#
sub _place {
    my ($self, %args) = @_;
    my $x     = $args {x};
    my $y     = $args {y};
    my $piece = $args {piece};

    die "Coordinates out of bounds\n" unless 
         $x =~ /^[0-9]+$/ && $y =~ /^[0-9]+$/ &&
         0 <= $x && $x < $self -> _x_size     &&
         0 <= $y && $y < $self -> _y_size;

    die "Invalid piece\n" unless
         $piece =~ /^[0-9]$/ &&
         0 <= $piece && $piece <= $self -> _nr_of_pieces;

    $board {$self} [$x] [$y] = $piece;
    $self;
}


# -----------------------------------------------------------------------------
# _parse_move
#
# Parses a move. Returns false if it cannot parse the moves, a 
# move in a generic format otherwise.
#
# Is often overriden in by a subclass.
#
# Generic allowed move formats:
#     1) "LN"           # Drops piece on field LN
#     2) "LN-LN(-LN)*   # Moves piece from LN to LN (to LN...)
#     3) "LNxLN(xLN)*   # Moves piece from LN to LN (to LN...) capturing
#                               enemy piece(s) in the process.
#
# "LN" is a field, following chess conventions: a letter followed by a number.
#
# Parameters:
#      move:   Move to be played
#
sub _parse_move {
    my ($self, %args) = @_;

    my $move = $args {move} // die "Missing argument 'move'";

    $move =~ s/^\s+//;
    $move =~ s/\s+$//;
    $move = lc $move;

    if ($move =~ /^(?<file>[a-z])(?<rank>[1-9][0-9]*)$/) {
        my $pos_x = ord ($+ {file}) - ord ('a');
        my $pos_y =      $+ {rank}  - 1;
        return [$MOVE_TYPE_DROP, [$pos_x => $pos_y]];
    }
    else {
        return;
    }
}



# -----------------------------------------------------------------------------
# _is_valid_move
#
# Tests whether a move is valid. Does not play the move. This is called
# after parsing a move, so we assume the move is in a generic format.
#
# Returns true if the move is valid, false otherwise. In the latter
# case, it'll set an error.
#
# Is often overriden in by a subclass.
#
sub _is_valid_move {
    my ($self, %args) = @_;

    my $move = $args {move} // die "Missing argument 'move'";

    $error {$self} = $MOVE_ERROR_MOVE_ACCEPTED;

    if ($$move [0] == $MOVE_TYPE_DROP) {
        unless ($self -> _allow_drops) {
            $error {$self} = $MOVE_ERROR_GAME_DOES_NOT_ALLOW_DROPS;
            return;
        }
        my $x = $$move [1] [0];
        my $y = $$move [1] [1];
        if ($x >= $self -> _x_size || $y >= $self -> _y_size) {
            $error {$self} = $MOVE_ERROR_FIELD_DOES_NOT_EXIST;
            return;
        }
        #
        # Find the piece. If there's no piece, default to the default
        # of the current player.
        #
        my $piece = $$move [2] ||
                     $self -> _player_piece
                              (player => $self -> _current_player);
        #
        # Can it be placed?
        #
        if ($self -> _piece (x => $x, y => $y)) {
            $error {$self} = $MOVE_ERROR_FIELD_OCCUPIED;
            return;
        }
        #
        # If the field exists, and isn't occupied, it's a valid move.
        #
        return 1;
    }
    else {
        #
        # Other move types not implemented yet.
        #
        ...;
    }
}



# -----------------------------------------------------------------------------
# _player_piece
#
# Returns the piece belonging to a given player. The default it to return
# the piece with the same index as the current player. This works for games
# like Go, Tic-Tac-Toe, Nine Men's Morris, Halma and others where each player
# only has one type of piece. Games for which this is not true, this method
# may need to be overridden.
#
sub _player_piece {
    my ($self, %args) = @_;

    my $player = $args {player} // die "Must have a player argument";

    $player;
}



# -----------------------------------------------------------------------------
# 
#
# Plays a move. Returns true if the move can be played. Returns false if
# a move cannot be played. If not, sets an error condition.
#
sub move {
    my ($self, %args) = @_;

    ...;
}



# -----------------------------------------------------------------------------
# _allow_drops 
#
# Returns false. Games which allow drops should override this.
#
sub _allow_drops {
    return 0;
}


# -----------------------------------------------------------------------------
# _may_drop_piece_on 
#
# Returns true if the given piece may be dropped on the given field.
# This base method allows dropping on any empty field (and not on a 
# non-occupied field). We may assume the given field exists in the 
# current board.
#
# It should set the reason why the piece cannot be dropped.
#
# This method is a prime candidate to be subclassed.
#
# Parameters:
#      piece:  The piece to be dropped. Irrelevant in this base case.
#      x, y:   Coordinates of the field it will be placed on.
#
sub _may_drop_piece_on {
    my ($self, %args) = @_;

    my $piece = $args {piece};
    my $x     = $args {x};
    my $y     = $args {y};

    if ($self -> _piece (x => $x, y => $y)) {
        $self -> _set_error (error => $MOVE_ERROR_FIELD_OCCUPIED);
        return;
    }

    return 1;
}


################################################################################
################################################################################
##                                                                            ##
## Accessors, not part of the public API; but subclases in this package       ##
## are free to make use of it.                                                ##
##                                                                            ##
################################################################################
################################################################################

# -----------------------------------------------------------------------------
# _board
# 
# Returns the stored board
#
sub _board {
    my $self = shift;
    $board {$self};
}


# -----------------------------------------------------------------------------
# _x_size
# 
# Returns the size of the board, in the X dimension
#
sub _x_size {
    my $self = shift;
    $x_size {$self};
}


# -----------------------------------------------------------------------------
# _y_size
# 
# Returns the size of the board, in the Y dimension
#
sub _y_size {
    my $self = shift;
    $y_size {$self};
}

# -----------------------------------------------------------------------------
# _nr_of_players
# 
# Returns the number of players.
#
sub _nr_of_players {
    my $self = shift;
    $nr_of_players {$self};
}

# -----------------------------------------------------------------------------
# _current_player
# 
# Returns the player whose move it currently is.
#
sub _current_player {
    my $self = shift;
    $current_player {$self};
}

# -----------------------------------------------------------------------------
# _nr_of_pieces
# 
# Returns the number of *different* pieces this game uses, not the
# total number of pieces which may appear on the board.
#
sub _nr_of_pieces {
    my $self = shift;
    $nr_of_pieces {$self};
}

# -----------------------------------------------------------------------------
# error
# 
# Returns the value of the last error set.
#
sub error {
    my $self = shift;
    $error {$self};
}


# -----------------------------------------------------------------------------
# _set_error
# 
# Set an error.
#
# Parameters:
#    error:  Error to set.
#
sub _set_error {
    my ($self, %args) = @_;
    $error {$self} = $args {error};
    $self;
}

# -----------------------------------------------------------------------------
# _game_finished
# 
# Returns false if the game is still in progress; otherwise, the reason
# why the game was finished.
#
sub _game_finished {
    my $self = shift;
    $game_finished {$self};
}


# -----------------------------------------------------------------------------
# _set_game_finished
# 
# Sets the finished state of a game.
#
# Parameters:
#     state
#
sub _set_game_finished {
    my $self  = shift;
    my %args  = @_;
    my $state = $args {state} // die "No state given";

    die "Illegal state '$state'"
         unless $state =~ /^[0-9]+$/ && $state < $GAME_STATE_MAX;

    $game_finished {$self} = $state;

    $self;
}


# -----------------------------------------------------------------------------
# _piece
# 
# Returns the piece on the given x and y coordinates.
#
sub _piece {
    my $self = shift;
    my %args = @_;
    my $x = $args {x} // die "Need an x coordinate";
    my $y = $args {y} // die "Need a y coordinate";
 
    die "Coordinates must be non-negative integers"
         unless $x =~ /^[0-9]+$/ && $y =~ /^[0-9]+$/;

    die "Coordinate out of bounds" if $x >= $x_size {$self} ||
                                      $y >= $y_size {$self};

    $board {$self} [$x] [$y];
}



# -----------------------------------------------------------------------------
# _winner
# 
# Returns the winner of the game.
#
sub _winner {
    my $self = shift;
    $winner {$self};
}


# -----------------------------------------------------------------------------
# _set_winner
# 
# Sets the winner of the game. Must be 0 (no winner) or one of the players.
#
# Parameters:
#     winner
#
sub _set_winner {
    my $self   = shift;
    my %args   = @_;
    my $winner = $args {winner} // die "No winner given";

    die "Illegal winner '$winner'"
         unless $winner =~ /^[0-9]+$/ && $winner <= $nr_of_players {$self};

    $winner {$self} = $winner;

    $self;
}



1;

__END__

=head1 NAME

Games::Record - Abstract

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/Games-Record.git >>.

=head1 AUTHOR

Abigail, L<< mailto:cpan@abigail.be >>.

=head1 COPYRIGHT and LICENSE

Copyright (C) 2015 by Abigail.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),   
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 INSTALLATION

To install this module, run, after unpacking the tar-ball, the 
following commands:

   perl Makefile.PL
   make
   make test
   make install

=cut
