
# Brush.pm - describes a "brush" in a csg modeling environment

package Games::3D::Brush;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Area;
use Games::3D::Thingy;
use vars qw/@ISA $VERSION @EXPORT_OK/;

@ISA = qw/Games::3D::Thingy Games::3D::Area Exporter/;
@EXPORT_OK= qw/
  BRUSH_CUBE BRUSH_WEDGE BRUSH_CYLINDER BRUSH_PYRAMID
  BRUSH_SOLID BRUSH_AIR BRUSH_WATER
/;

use SDL::OpenGL;

$VERSION = '0.02';

##############################################################################
# constants

sub BRUSH_CUBE () { 0; }
sub BRUSH_WEDGE () { 1; }
sub BRUSH_CYLINDER () { 2; }
sub BRUSH_PYRAMID () { 3; }

sub BRUSH_SOLID () { 0; }
sub BRUSH_AIR () { 1; }
sub BRUSH_WATER () { 2; }

sub BRUSH_MAX_SIDES () { 32; }

my $coord = 
  {
  cube => pack ("d24",
	-0.5,-0.5,-0.5, 0.5,-0.5,-0.5, 0.5,0.5,-0.5, -0.5,0.5,-0.5, 	# back
	-0.5,-0.5, 0.5, 0.5,-0.5, 0.5, 0.5,0.5, 0.5, -0.5,0.5, 0.5),	# front
  };

my $geo = 
  {
  cube_solid => [ 24, 0,		# 6 quads, 0 triangles
	pack ("C24",
	 4,5,6,7,	# front
	 1,2,6,5,	# right
	 0,1,5,4,	# bottom
	 0,3,2,1,	# back
	 0,4,7,3,	# left
	 2,3,7,6),	# top
        ],
  cube_air => [ 24, 0,		# 6 quads, 0 triangles
        pack ("C24",
	 7,6,5,4,	# front
	 5,6,2,1,	# right
	 4,5,1,0,	# bottom
	 1,2,3,0,	# back
	 3,7,4,0,	# left
	 6,7,3,2),	# top
        ],
  wedge_solid => [ 12, 8,	# 3 quads and 2 triangles
	pack ("C24",
	 4,5,1,0,	# bottom
	 1,2,3,0,	# back
	 4,5,3,2),	# top
	pack ("C6",
	 3,4,0,		# left
	 5,2,1),	# right
	],
  wedge_air => [ 12, 8, 		# 3 quads and 2 triangles
	pack ("C24",
	 0,1,5,4,	# bottom
	 0,3,2,1,	# back
	 2,3,5,4),	# top
	pack ("C6",
	 0,4,3,		# left
	 1,2,5),	# right
	],
  };

my $shape_names = 
  {
  BRUSH_CUBE() => 'cube',
  BRUSH_WEDGE() => 'wedge',
  };

my $type_names = 
  {
  BRUSH_AIR() => 'air',
  BRUSH_WATER() => 'water',
  BRUSH_SOLID() => 'solid',
  };


my $render_shape = 
  {
  BRUSH_CUBE() => 'cube',
  BRUSH_WEDGE() => 'cube',	# re-uses cube
  };

my $render_type = 
  {
  BRUSH_AIR() => 'air',
  BRUSH_WATER() => 'solid',
  BRUSH_SOLID() => 'solid',
  };

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  Games::3D::Area::_init($self,$args);
  $self->SUPER::_init($args);

  $self->{shape} = $args->{shape} || BRUSH_CUBE;
  $self->{type} = $args->{type} || BRUSH_SOLID;
  
  $self->{sides} = 4;
  if ($self->{shape} != BRUSH_CUBE &&
      $self->{shape} != BRUSH_WEDGE)
    {
    $self->{sides} ||= $args->{sides};
    }

  $self;
  }

sub shape
  {
  my $self = shift;
  if (@_ > 0)
    {
    $self->{shape} = shift;
    }
  $self->{shape};
  }

sub sides
  {
  my $self = shift;
  if (@_ > 0)
    {
    $self->{sides} = shift;
    $self->{sides} = 4 if $self->{shape} == BRUSH_WEDGE ||
                          $self->{shape} == BRUSH_CUBE;
    }
  $self->{sides};
  }

sub type
  {
  my $self = shift;
  if (@_ > 0)
    {
    $self->{type} = shift;
    }
  $self->{type};
  }

sub render
  {
  my ($self,$camera) = @_;

  my $shape = $render_shape->{$self->{shape}};
  my $vert_shape = $shape_names->{$self->{shape}};
  my $type = $render_type->{$self->{type}};

  glPushMatrix();
    glTranslate($self->{x},$self->{y},$self->{z});
    glScale($self->{w},$self->{h},$self->{l});
    glColor($self->{id} * 0.3,$self->{id} * 0.2 ,$self->{id} * 0.2);
    glDisableClientState(GL_COLOR_ARRAY());
    glEnableClientState(GL_VERTEX_ARRAY());
    glVertexPointer(3,GL_DOUBLE(),0,$coord->{$shape});

    # draw quads first
    my $g = $geo->{$vert_shape.'_'.$type};

    glDrawElements( GL_QUADS(),$g->[0],GL_UNSIGNED_BYTE(), $g->[2]);

    # if we have triangles, draw them also
    glDrawElements( GL_TRIANGLES(),$g->[1],GL_UNSIGNED_BYTE(), $g->[3])
      if $g->[1] != 0;

  glPopMatrix();
   
  #if ($self->id() == 3)
    { 
    $self->{x} += 0.2 if rand(50) <= 2;
    $self->{y} += 0.2 if rand(50) <= 2;
    }
  }

sub vertices
  {
  # return the vertices of the brush (before rotation and translation) as a
  # list of 3 values per vertice (e.g. a collapsed array of coordinates)
  my $self = shift;

  my $shape = $render_shape->{$self->{shape}};
  $coord->{$shape};
  }

sub vertices_final
  {
  # return the vertices of the brush (after rotation and translation) as a
  # list of 3 values per vertice (e.g. a collapsed array of coordinates)
  my $self = shift;

  my $shape = $render_shape->{$self->{shape}};
  my @coo = $coord->{$shape};
  my @vertices = ();
  for (my $i = 0; $i < scalar @coo; $i += 3)
    {
    my $vertice = Games::3D::Vector->new($coo[$i],$coo[$i+1],$coo[$i+2]);
    $vertice->scale($self->{w},$self->{h},$self->{l});
    $vertice->rotate($self->{xr},$self->{yr},$self->{zr});
    $vertice->translate($self->{x},$self->{y},$self->{z});
    push @vertices, $vertice->pos();
    }
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Brush - describes a "brush" in a csg modeling environment

=head1 SYNOPSIS

	use Games::3D::Brush qw/BRUSH_CUBE/;
	use Games::3D::Level;

	my $cube = Games::3D::Brush->new( type => BRUSH_CUBE );
	my $level = Games::3D::Level->new();
	$level->add($cube);
	$level->render();

=head1 EXPORTS

Exports nothing on default. Can export the following constants.
  
	BRUSH_CUBE BRUSH_WEDGE BRUSH_CYLINDER BRUSH_PYRAMID
	BRSUH_SOLID BRUSH_AIR BRUSH_WATER

	BRUSH_MAX_SIDES

=head1 DESCRIPTION

This package provides a class for representing a brush in the world. Brushes
come in different shapes (cubes, wedges etc) and different kinds (air,
solid, water etc).

=head1 METHODS

It features all the methods of Games::3D::Area (namely: new(), _init(),
x(), y(), z(), width(), height(), length(), pos(), size() and pos()) plus:

=over 2

=item render()

	$brush->render($camera);

Renders the brush.

=item shape()

	print $brush->shape();
	$brush->shape(BRUSH_WEDGE);
	
Set and return or just return the brush's shape.

=item type()

	print $brush->type();
	$brush->type(BRUSH_SOLID);
	
Set and return or just return the brush's type.

=item vertices()

	my @vertices = $brush->vertices();
	
Return all the vertices from the brush as unrotated, unscale and untranslated.
Can be used to get the basic geometric form of the brush.

=item vertices_final()

	my @vertices = $brush->vertices();
	
Return all the vertices from the brush as rotated, scaled and translated, e.g
at the position of the brush inside the level. This can be used to find brushes
which share vertices or edges or sides.

=item sides()

	$brush->sides(4);
	if ($bruhs->side() != 4) { ... }

Set and return or just return the number of sides the brush has. Cubes and
wedges always have 4, but cylinders or pyramids may have between 3 and 
L<BRUSH_MAX_SIDES>. 
	
=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Area> as well as L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

