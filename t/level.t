#!/usr/bin/perl -w

use Test::More tests => 4;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Level'); 
  }

can_ok ('Games::3D::Level', qw/ 
  new _init 
  render add_brush brushes
  _load _build_portals rooms
  /);

my $level = Games::3D::Level->new ( file => 'levels/level00.txt' );

is (ref($level), 'Games::3D::Level', 'new worked');

is ($level->brushes(), 0, '0 brushes');

