#!/usr/bin/perl -w

use Test::More tests => 8;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Mass'); 
  }

can_ok ('Games::3D::Mass', qw/ 
  new _init 
  clear_forces
  apply_force
  update
  speed
  force
  mass
  /);

my $mass = Games::3D::Mass->new ( );

is (ref($mass), 'Games::3D::Mass', 'new worked');

is (join(",",$mass->pos()), "0,0,0", 'pos is 0,0,0');

is (ref($mass->force()), 'Games::3D::Vector', 'force is a vector');
is ($mass->force()->length(), 0, 'zero force');

# simulate 100 ms of time
$mass->update(100);
is ($mass->force()->length(), 0, 'still zero force');
is (join(",",$mass->pos()), "0,0,0", 'pos is still 0,0,0');

