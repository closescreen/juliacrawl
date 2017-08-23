#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;


$|=1;
my ($file) = @ARGV;
open( my $urls, $file) or die "cant open $file: $!";
my %doms;


while (<$urls>){
 chomp;
 m|/| and next; # с путями нам не нужны
 s|^.+?\://||; 
 s|www\.||;
 $_ or next;
 $doms{$_}+=1;
}

# на входе refs из hl
while( my $ref = <STDIN>){ 
 $ref or next;
 $ref =~s|[\'\s]||g; # очищаем от кавычек
 $ref or next;
 $ref =~s|^.+?\://||; # очищаем от протокола
 $ref =~s|www\.||; # - от www.
 $ref or next;
 my ($dom) = $ref=~m{(.+?)(?=/|\Z)} or die "$ref not match"; # выделяем домен 
 #my ($dom,$path)= split(/\//,$ref,2); # без пути (корневые не интересны) / пока фильтрацию оставил на потом
 $dom or next;
 my @dom = split /\./, $dom; # уровни домена
 my $dom2l = @dom<=2 ? undef: join(".", @dom[-2,-1]); # домен второго уровня

 if ( $doms{$dom} or ($dom2l and $doms{$dom2l}) ){ # домен или домен 2 уровня есть в справочнике?
    print $ref,"\n";
 }
}
