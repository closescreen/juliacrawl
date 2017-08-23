#!/usr/bin/env perl
выкинуть
use strict;
use warnings;
use Encode;

while(<>){
 if( my ($p) = m|<title>(.+?)</title>| ){ 
    print $p=~m|\\\d+| ? Encode::encode("utf8",$p) : $p  
 }
}

