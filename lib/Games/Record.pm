package Games::Record;

use 5.010;
use strict;
use warnings;
no  warnings 'syntax';

use Hash::Util::FieldHash qw [fieldhash];
use Games::Record::Constants;

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
    push @$board => [(0) x $args {x_size}] for 1 .. $args {y_size};

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
         unless $state =~ /^[0-9]+$/ && $state <= $GAME_STATE_MAX;

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
