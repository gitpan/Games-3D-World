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
  /);

my $level = Games::3D::Level->new ( );

is (ref($level), 'Games::3D::Level', 'new worked');

is ($level->brushes(), 0, '0 brushes');

