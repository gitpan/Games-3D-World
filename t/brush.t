#!/usr/bin/perl -w

use Test::More tests => 54;
use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, '../blib/lib';
  unshift @INC, '../blib/arch';
  unshift @INC, '.';
  chdir 't' if -d 't';
  use_ok ('Games::3D::Brush', 
    qw/
	BRUSH_CUBE BRUSH_WEDGE BRUSH_CYLINDER BRUSH_PYRAMID
	BRUSH_AIR BRUSH_WATER BRUSH_SOLID
    /);
  }

can_ok ('Games::3D::Brush', qw/ 
  new _init x y z
  size width height length shape pos
  render type sides
  vertices vertices_final faces
  default_texture
  /);

my $brush = Games::3D::Brush->new ( );

is (ref($brush), 'Games::3D::Brush', 'new worked');

is ($brush->x(), 0, 'X is 0');
is ($brush->y(), 0, 'Y is 0');
is ($brush->z(), 0, 'Z is 0');
is (join(",",$brush->pos()), '0,0,0', 'center is 0,0,0');
is ($brush->shape(), BRUSH_CUBE, 'shaped like a cube');
is ($brush->type(), BRUSH_SOLID, 'solid like a rock');
is ($brush->sides(), 4, '4-sided');

$brush = Games::3D::Brush->new ( type => BRUSH_AIR );
is (ref($brush), 'Games::3D::Brush', 'new worked');

is (join(":",$brush->vertices()), '-0.5:-0.5:-0.5:0.5:-0.5:-0.5:0.5:0.5:-0.5:-0.5:0.5:-0.5:-0.5:-0.5:0.5:0.5:-0.5:0.5:0.5:0.5:0.5:-0.5:0.5:0.5', 'vertice list');

is (join(":",$brush->vertices_final()), '-0.5:-0.5:-0.5:0.5:-0.5:-0.5:0.5:0.5:-0.5:-0.5:0.5:-0.5:-0.5:-0.5:0.5:0.5:-0.5:0.5:0.5:0.5:0.5:-0.5:0.5:0.5', 'vertice list final');

is (ref($brush->faces()), 'ARRAY', 'faces');

my $txt = '';
foreach my $face (@{$brush->faces})
  {
  is (ref($face),'HASH', 'face is a hash');
  is ($face->{type},'quad', 'quad');
  is (@{$face->{vertices}}, 4, '4 vertices');
  foreach my $v (@{$face->{vertices}})
    {
    $txt .= join(':',$v->pos);
    }
  }

# since x,y,z, and w,h,l are 0:
is ($txt, "-0.5:0.5:0.50.5:0.5:0.50.5:-0.5:0.5-0.5:-0.5:0.50.5:0.5:0.50.5:0.5:-0.50.5:-0.5:-0.50.5:-0.5:0.5-0.5:-0.5:-0.5-0.5:-0.5:0.50.5:-0.5:0.50.5:-0.5:-0.50.5:0.5:-0.5-0.5:0.5:-0.5-0.5:-0.5:-0.50.5:-0.5:-0.5-0.5:0.5:-0.5-0.5:0.5:0.5-0.5:-0.5:0.5-0.5:-0.5:-0.50.5:0.5:0.5-0.5:0.5:0.5-0.5:0.5:-0.50.5:0.5:-0.5", 'faces ok');

is ($brush->x(12), 12, 'X is 12');
is ($brush->x(), 12, 'X is 12');
is ($brush->y(34), 34, 'Y is 34');
is ($brush->y(), 34, 'Y is 34');
is ($brush->x(56), 56, 'X is 56');
is ($brush->x(), 56, 'X is 56');

is (join(",",$brush->size()), '1,1,1', 'size is 0,0,0');
is ($brush->width(), 1, 'w is 1');
is ($brush->length(), 1, 'l is 1');
is ($brush->height(), 1, 'h is 1');

is ($brush->width(12), 12, 'w is 12');
is ($brush->width(), 12, 'w is 12');
is ($brush->length(34), 34, 'l is 34');
is ($brush->length(), 34, 'l is 34');
is ($brush->height(56), 56, 'h is 56');
is ($brush->height(), 56, 'h is 56');


is ($brush->shape(BRUSH_WEDGE), BRUSH_WEDGE, 'now wedge');
is ($brush->type(BRUSH_AIR), BRUSH_AIR, 'hot air');

is ($brush->shape(BRUSH_CYLINDER), BRUSH_CYLINDER, 'column');
is ($brush->sides(6), 6, '6-sided');
is ($brush->sides(), 6, '6-sided');

