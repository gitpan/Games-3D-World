
# Object - renderable mass with a size

package Games::3D::Object;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Area;
use Games::3D::Mass;
use Games::3D::Vector;
use vars qw/@ISA $VERSION/;

use SDL::OpenGL;

@ISA = qw/Games::3D::Mass Games::3D::Area Exporter/;

$VERSION = '0.01';

##############################################################################
# constants for rendering the default model

my $coord =
  pack ("d24",
        -0.5,-0.5,-0.5, 0.5,-0.5,-0.5, 0.5,0.5,-0.5, -0.5,0.5,-0.5,     # back
        -0.5,-0.5, 0.5, 0.5,-0.5, 0.5, 0.5,0.5, 0.5, -0.5,0.5, 0.5);    # front

my $geo = pack ("C24",
         4,5,6,7,       # front
         1,2,6,5,       # right
         0,1,5,4,       # bottom
         0,3,2,1,       # back
         0,4,7,3,       # left
         2,3,7,6);      # top

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

  $self->{model} = $args->{model} || 'none';

  $self;
  }

sub render
  {  
  my $self = shift;

  glPushMatrix;
    glTranslate($self->{x},$self->{y},$self->{z});
    glScale($self->{w},$self->{h},$self->{l});
    glColor(1,1,1,0.8);
    glEnableClientState(GL_VERTEX_ARRAY());
    glVertexPointer(3,GL_DOUBLE(),0,$coord);
    glDrawElements(GL_QUADS(), 24, GL_UNSIGNED_BYTE(), $geo);
  glPopMatrix;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Object - a renderable object

=head1 SYNOPSIS

	use Games::3D::Object;

	my $obj = Games::3D::Object->new( mass => 123, model => 'default' );
	$obj->clear_force();
	$obj->apply_force( $vector );
	$obj->simulate();
	$obj->render();

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for objects in 3D space. These derive from
Games::3D::Mass (point-like mass) and Games::3D::Area.

=head1 METHODS

It features all the methods of Games::3D::Mass and Games::3D::Area, plus:

=over 2

=item render

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Area> as well as L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

