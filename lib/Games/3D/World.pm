
# This is just the version number and the documentation (for now)

package Games::3D::World;

# (C) by Tels <http://bloodgate.com/>

use strict;
use Games::3D::Thingy;
use SDL::OpenGL;
use Games::3D::Level;

use Games::3D::PhysEng;

use vars qw/@ISA $VERSION/;

@ISA = qw/Games::3D::Thingy Exporter/;

$VERSION = '0.05';

##############################################################################
# methods

sub _init
  {
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->{camera_pos} = [ 0,0,0 ];
  $self->{camera_lookat} = [ 0,0,-1 ];

  $self->{level} = Games::3D::Level->new ( file => $args->{level} );
  
  $self->{physeng} = Games::3D::PhysEng->new();

  $self;
  }

sub camera
  {
  my $self = shift;

  if (@_ > 0)
    {
    $self->{camera_pos} = [ $_[0], $_[1], $_[2] ];
    $self->{camera_lookat} = [ $_[3], $_[4], $_[5] ];
    gluLookAt( @{$self->{camera_pos}}, @{$self->{camera_lookat}}, 0,1,0);
    }
  @{$self->{camera_pos}}, @{$self->{camera_lookat}};
  }

sub add_objects
  {
  my $self = shift;

  push @{$self->{objects}}, @_;

  # register it with our physeng
  $self->{physeng}->add_mass(@_);
  $self;
  }

sub render
  {
  my ($self,$current_time) = @_;

  $self->{physeng}->update($current_time);

  # find out in which room the camera is and render from there
  $self->{level}->render();

  # render all the objects
  foreach my $obj (@{$self->{objects}})
    {
    $obj->render();
    }
  $self;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::World - 3D level, camera etc, that can be rendered with OpenGL

=head1 SYNOPSIS

	use Games::3D::World;

	my $world = Games::3D::World->new( level => 'level01.txt' );

	# set up camera
	$world->camera( $x, $y, $z, $lookatx, $lookaty, $lookatz);
	...

	$world->render();

=head1 EXPORTS

Exports nothing.

=head1 DESCRIPTION

This package contains a complete 3D world, with a level (the geometry), 
brushes, lights, camera, etc.

It can render the scene with OpenGL.

For now, this package is empty, but it will later encompass all the classes
contained in here.

=head1 METHODS

=head2 new()

	my $world = Games::3D::World->new( level => 'levels/level00.txt' );

Create a new world, either from an empty level or from a savegame.

=head2 camera()

	my ($x,$y,$z,$lx,$ly,$lz) =  $world->camera();
	$world->camera( $x, $y, $z, $lookatx, $lookaty, $lookatz);

Set up the camera, and return position and look-at point of the camera.

=head2 render()

	$world->render($current_time);

Update the physeng to catch up to C<$current_time>, then render the world from
the camera view.

=head2 add_objects()

	$world->add_objects();

Add one ore more objects to the world, so that they can be rendered. They
must support the render() method.

=head1 BUGS

None known yet.

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

L<GAME::3D::Vector>,  L<GAME::3D::Brush>,  L<GAME::3D::Level>.

=cut

