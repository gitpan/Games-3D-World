#!/usr/bin/perl -w

# test attractors

use Test::More tests => 4;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Attractor'); 
  }

can_ok ('Games::3D::Attractor', qw/ 
  new _init 
  clear_forces
  apply_force
  update
  speed
  force
  mass
  attract
  type
  /);

my $mass = Games::3D::Attractor->new ( );

is (ref($mass), 'Games::3D::Attractor', 'new worked');

is (join(",",$mass->pos()), "0,0,0", 'pos is 0,0,0');

#is (ref($mass->force()), 'Games::3D::Vector', 'force is a vector');
#is ($mass->force()->length(), 0, 'zero force');
#
## simulate 100 ms of time
#$mass->update(100);
#is ($mass->force()->length(), 0, 'still zero force');
#is (join(",",$mass->pos()), "0,0,0", 'pos is still 0,0,0');

