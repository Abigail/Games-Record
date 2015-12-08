package Games::Record::RowGames;

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Games::Record;

our @ISA = qw [Games::Record];


sub init {
    my $self = shift;

    $self -> SUPER::init (nr_of_pieces => 2, @_);
    $self;
}

1;


__END__

=pod
