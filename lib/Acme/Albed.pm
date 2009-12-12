package Acme::Albed;

use Any::Moose;
use utf8;
use YAML;
use Data::Dumper;
use Carp;
our $VERSION = '0.01';

has albedian => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

sub dict {
    my ($self, $path) = @_;
    my $dict = Load(<<'...');
a:
  before: 'あ,い,う,え,お'
  after: 'ワ,ミ,フ,ネ,ト'
ka:
  before: 'か,き,く,け,こ'
  after: 'ア,チ,ル,テ,ヨ'
sa:
  before: 'さ,し,す,せ,そ'
  after: 'ラ,キ,ヌ,ヘ,ホ'
ta:
  before: 'た,ち,つ,て,と'
  after: 'サ,ヒ,ユ,セ,ソ'
na:
  before: 'な,に,ぬ,ね,の'
  after: 'ハ,シ,ス,メ,オ'
ma:
  before: 'ま,み,む,め,も'
  after: 'ヤ,イ,ツ,レ,コ'
ya:
  before: 'や,ゆ,よ'
  after: 'タ,モ,ヲ'
ra:
  before: 'ら,り,る,れ,ろ'
  after: 'ナ,ニ,ウ,エ,ノ'
wa:
  before: 'わ,を,ん'
  after: 'カ,ム,ン'
ga:
  before: 'が,ぎ,ぐ,げ,ご'
  after: 'ダ,ヂ,ヅ,デ,ゾ'
za:
  before: 'ざ,じ,ず,ぜ,ぞ'
  after: 'バ,ビ,ブ,ゲ,ボ'
da:
  before: 'だ,ぢ,づ,で,ど'
  after: 'ガ,ギ,グ,ベ,ゴ'
ba:
  before: 'ば,び,ぶ,べ,ぼ'
  after: 'ザ,ジ,ズ,ゼ,ド'
pa:
  before: 'ぱ,ぴ,ぷ,ぺ,ぽ'
  after: 'プ,ポ,ピ,パ,ペ'
la:
  before: 'ぁ,ぃ,ぅ,ぇ,ぉ'
  after: 'ァ,ィ,ゥ,ェ,ォ'
ltu:
  before: 'っ,ゃ,ゅ,ょ'
  after: 'ッ,ャ,ュ,ョ'
en:
  before: 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
  after: 'y,p,l,t,a,v,k,r,e,z,g,m,s,h,u,b,x,n,c,d,i,j,f,q,o,w'
...
    return $dict;
}

has source => (
    is  => 'rw',
    isa => 'Str',
);

sub to_albed {
    my ( $self, $arg ) = @_;
    my $source = $arg || $self->source;
    return unless $source;
    my $len = length($source) - 1;
    my $res;
    for my $i ( 0 ... $len ) {
        my $char = substr( $source, $i, 1 );
        return unless ( defined $char && $char ne "");
        $res .= $self->_conv_to_albed( $char );
    }
    unless ( defined $res && $res ne "" ) {
        croak "Invalied input: $source";
    }
    return $res;
}

sub _conv_to_albed {
    my ( $self, $char ) = @_;
    return unless ( defined $char && $char ne "" );

    my $result;
    my @mos  = keys( %{$self->dict} );
    my $dict = $self->dict;
    foreach my $key (@mos) {
        my $source = $dict->{$key}->{before};
        my $conv   = $dict->{$key}->{after};
        if ( $result = $self->_data_comp( $char, $source, $conv ) ) {
            return $result;
        }
    }
    return;
}

sub _data_comp {
    my ( $self, $char, $source, $conv ) = @_;
    $" = "|";
    my @source = split( /,/, $source );
    my @conv   = split( /,/, $conv );
    if ( $char =~ /(@source)/ ) {
        for my $i ( 0 ... @source - 1 ) {
            if ( $char eq $source[$i] ) {
                return $conv[$i];
            }
        }
    }
    return;
}

1;
__END__

=head1 NAME

Acme::Albed - Convert from/to Albedian.

=head1 SYNOPSIS

  use Acme::Albed;
  my $albed = Acme::Albed->new();
  my $res = $albed->to_albed("...");

=head1 DESCRIPTION

Acme::Albed convert from/to Albedian.
Albedian is fiction language on FinalFantasy X, and simple substitution cipher. 

=head1 AUTHOR

haoyayoi E<lt>st.hao.yayoi@gmail.comE<gt>

=head1 SEE ALSO

http://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%AB%E3%83%99%E3%83%89%E8%AA%9E

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
