#!/usr/bin/perl -w

# test rooms

use Test::More tests => 3;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Room'); 
  }

can_ok ('Games::3D::Room', qw/ 
  new _init 
  render
  traverse
  add_faces
  add_portals
  _render_faces
  default_texture
  /);

my $room = Games::3D::Room->new ( );

is (ref($room), 'Games::3D::Room', 'new worked');

