#!/usr/bin/perl -w

use Test::More tests => 3;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::World'); 
  }

can_ok ('Games::3D::World', qw/ 
  new _init 
  render camera
  /);

my $world = Games::3D::World->new ( level => 'levels/level00.txt' );

is (ref($world), 'Games::3D::World', 'new worked');


