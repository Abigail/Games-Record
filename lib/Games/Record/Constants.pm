package Games::Record::Constants;

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

our $VERSION = '2015120801';

use Exporter ();

our @ISA    = qw [Exporter];
our %EXPORT_TAGS;


my %sets = (
    #
    # Reasons why a game was finished
    #
    GAME_STATE => {
        prefix => "GAME_" ,
        data   => <<"        --",
            IN_PROGRESS      #  Not finished
            DECIDED          #  A deciding move was played.
            DRAWN            #  Position is a draw.
            RESIGNED         #  A player resigned.
            TIMED_OUT        #  The game timed out for a player.
            DRAW_AGREED      #  Players agreed on a draw.
            TECHNICAL_DRAW   #  Repeated positions, too many moves, etc.
            STATE_MAX        #  One more than the max allowed value.
        --
    },

    #
    # Reasons a move cannot be played
    #
    MOVE_ERRORS => {
        prefix => "MOVE_ERROR_",
        data   => <<"        --",
            MOVE_ACCEPTED
            FAILED_TO_PARSE
            GAME_FINISHED
            FIELD_DOES_NOT_EXIST
            NOT_PLAYERS_TURN
            GAME_DOES_NOT_ALLOW_DROPS
            FIELD_OCCUPIED
            MAX
        --
    },

    #
    # Move types
    #
    MOVE_TYPES => {
        prefix => "MOVE_TYPE_",
        data   => <<"        --",
            DROP
            MOVE
            TAKE
            MAX
        --
    },
);
while (my ($tag, $set) = each %sets) {
    my $prefix = $$set {prefix} // "";
    my @lines = split /\n/ => $$set {data};
    for (my $i = 0; $i < @lines; $i ++) {
        my ($name) = $lines [$i] =~ /(\S+)/;
        no strict 'refs';
        no warnings 'once';
        ${__PACKAGE__ . "::${prefix}${name}"} = $i;
        push @{$EXPORT_TAGS {$tag}} => "\$${prefix}${name}";
    }
}

our @EXPORT_OK = map {@$_} values %EXPORT_TAGS;
$EXPORT_TAGS {ALL} = \@EXPORT_OK;   # Dumb exporter, not having ALL.


1;

__END__

=pod
