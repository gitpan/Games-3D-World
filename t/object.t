#!/usr/bin/perl -w

use Test::More tests => 9;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Object'); 
  }

can_ok ('Games::3D::Object', qw/ 
  new _init 
  clear_forces
  apply_force
  update
  speed
  force
  mass
  render
  /);

my $obj = Games::3D::Object->new ( );

is (ref($obj), 'Games::3D::Object', 'new worked');
is ($obj->{static}, 0, 'non static');

is (join(",",$obj->pos()), "0,0,0", 'pos is 0,0,0');

is (ref($obj->force()), 'Games::3D::Vector', 'force is a vector');
is ($obj->force()->length(), 0, 'zero force');

# simulate 100 ms of time
$obj->update(100);
is ($obj->force()->length(), 0, 'still zero force');
is (join(",",$obj->pos()), "0,0,0", 'pos is still 0,0,0');

