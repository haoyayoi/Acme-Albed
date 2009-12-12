use strict;
use Test::Base tests => 101;
use Acme::Albed;
use utf8;

my $albed = Acme::Albed->new;
my $dic   = $albed->dict;
for my $key (keys %$dic) {
    my @char_ja = split(',', delete $dic->{$key}->{before}) if $dic->{$key}->{before};
    my @char_al = split(',', delete $dic->{$key}->{after}) if $dic->{$key}->{after};
    foreach my $i ( 0 .. $#char_ja ) {
        is ($albed->to_albed($char_ja[$i]), $char_al[$i]);
    }
}

