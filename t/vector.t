#!/usr/bin/perl -w

use Test::More tests => 19;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Vector'); 
  }

can_ok ('Games::3D::Vector', qw/ 
  new _init x y z
  pos
  rotate translate scale length flip
  cross dot copy
  add subtract divide mul
  /);

##############################################################################
# new

my $vec = Games::3D::Vector->new ( );

is (ref($vec), 'Games::3D::Vector', 'new worked');

is (join(',',$vec->pos()), '0,0,0', 'pos is 0');
is ($vec->length(), '0', 'len is 0');

$vec = Games::3D::Vector->new ( x => 12, y => 8, z => 9);
is (join(',',$vec->pos()), '12,8,9', 'pos is 12,8,9');

$vec = Games::3D::Vector->new ( 12, 8, 9);
is (join(',',$vec->pos()), '12,8,9', 'pos is 12,8,9');

##############################################################################
# vector math

for my $k (0..2)
  {
  my @a = (0,0,0); $a[$k] = 12;
  $vec = Games::3D::Vector->new ( @a );	# sqrt(144) = 12
  is ($vec->length(), 12, 'len is 12'); 
  @a = (0,3,4);
  for my $i (0..$k)
    {
    push @a, $a[0]; shift @a;		# rotate around
    }
  $vec = Games::3D::Vector->new ( @a );	# 9+16 = 25 => 5
  is ($vec->length(), 5, 'len is 5'); 
  }

$vec = Games::3D::Vector->new ( 12, 8, 9);
$vec->scale(-1);
is (join(',',$vec->pos()), '-12,-8,-9', 'pos is -12,-8,-9');
$vec->flip();
is (join(',',$vec->pos()), '12,8,9', 'pos is 12,8,9');
$vec->mul(-1,2,3);
is (join(',',$vec->pos()), '-12,16,27', 'pos is -12,16,27');

##############################################################################
# copy

$vec = Games::3D::Vector->new ( 12, 8, 9);
my $vec2 = $vec->copy();
is (join(',',$vec2->pos()), '12,8,9', 'pos is 12,8,9');

$vec = Games::3D::Vector->new ( 2, 3, 4);
$vec2 = Games::3D::Vector->new ( 4, 3, 2);

is ($vec->dot($vec2), 4*2 + 3*3 + 4*2, 'dot product');

is (join(",",$vec->cross($vec2)->pos()), '-6,12,-6', 'cross product');

