#! /usr/bin/perl -w

use strict;

my $block = 0;
while (<>) {
 $block= 1 if (/<!--\s+Begin[\w\s]+Footer\s+-->/);
 print if (!$block); 
 $block= 0 if (/<!--\s+End[\w\s]+Footer\s+-->/);
}
