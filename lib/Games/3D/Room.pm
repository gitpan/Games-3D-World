
# Room.pm - describes a "room" in portal-render (rooms are connectd by portals)

package Games::3D::Room;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Area;
use Games::3D::Thingy;
use vars qw/@ISA $VERSION/;

@ISA = qw/Games::3D::Thingy Games::3D::Area Exporter/;

use SDL::OpenGL;

$VERSION = '0.01';

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

  $self->{faces} = [ ];
  $self->{portals} = [ ];
  
  $self->{face_quad_vertices} = [];
  $self->{face_triangle_vertices} = [];
  $self->{portal_quad_vertices} = [];
  $self->{portal_triangle_vertices} = [];
  $self->{build} = 0;
  $self->{default_texture} = $args->{default_texture};

  $self;
  }

sub default_texture
  {
  my $self = shift;

  $self->{default_texture} = $_[0] if @_ > 0;
  $self->{default_texture};
  }

sub add_faces
  {
  my $self = shift;

  $self->{build} = 0;
  push @{$self->{faces}}, @_;
  }

sub add_portals
  {
  my $self = shift;

  $self->{build} = 0;
  push @{$self->{portals}}, @_;
  }

sub faces
  {
  my $self = shift;

  @{$self->{faces}};
  }

sub portals
  {
  my $self = shift;

  @{$self->{portals}};
  }

sub traverse
  {
  my ($self,$mark,$stack) = @_;

  foreach my $portal (@{$self->{portals}})
    {
    next if exists $mark->{$portal->id()};
    $mark->{$portal->id()} = 1;		# mark as visited
    push @$stack, $portal;
    $portal->room->traverse($mark,$stack);
    }
  }

sub _build_vertices
  {
  my $self = shift;
     
  $self->{face_quad_vertices} = [];
  $self->{face_triangle_vertices} = [];
  $self->{portal_quad_vertices} = [];
  $self->{portal_triangle_vertices} = [];

  foreach my $face (@{$self->{faces}})
    {
    my $t = 'face_' . $face->{type} . '_vertices';
    my $i = 0;
#      use Data::Dumper; print Dumper($face->{texcoord}),"\n";
    foreach my $v (@{$face->{vertices}})
      {
      push @{$self->{$t}}, [ $v->{x}, $v->{y}, $v->{z},  
        $face->{texcoord}->[$i++],
        $face->{texcoord}->[$i++],
        ];
      }
    }
  foreach my $face (@{$self->{portals}})
    {
    my $t = 'portal_' . $face->{type} . '_vertices';
    my $i = 0;
    foreach my $v (@{$face->{vertices}})
      {
      push @{$self->{$t}}, [ $v->{x}, $v->{y}, $v->{z},
        $face->{texcoord}->[$i],
        $face->{texcoord}->[$i+1],
        ];
      $i += 2;
      }
    }
  $self->{build} = 1;
  }

sub _render_faces
  {
  my $self = shift;

  $self->_build_vertices() unless $self->{build} == 1;

  my $i = 0;

  #glPushMatrix();
    #glTranslate($self->{x},$self->{y},$self->{z});
    #glScale($self->{w},$self->{h},$self->{l});

   # glColor($self->{id} * 0.3,$self->{id} * 0.2 ,$self->{id} * 0.2, 0.4);
    glColor( 1,1,1,0.6);

    glBindTexture( GL_TEXTURE_2D, $self->{default_texture} );
    glEnable(GL_TEXTURE_2D);
 
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);

    if (scalar @{$self->{face_quad_vertices}} > 0)
      {
    
      #print "\n";
      glBegin(GL_QUADS);
      #glColor($self->{id} * 0.3 + $i,
      #        $self->{id} * 0.2 + $i,
      #        $self->{id} * 0.2 + $i, 0.2); $i += 0.15;

      my $f = $self->{face_quad_vertices}; my $ff;
      for ($i = 0; $i < @$f; )
        {

        $ff = $f->[$i++];
	#print join (":",@$ff,"\n");
        glTexCoord($ff->[3], $ff->[4]);
        glVertex($ff->[0],$ff->[1],$ff->[2]);
        $ff = $f->[$i++];
	#print join (":",@$ff,"\n");
        glTexCoord($ff->[3], $ff->[4]);
        glVertex($ff->[0],$ff->[1],$ff->[2]);
        $ff = $f->[$i++];
	#print join (":",@$ff,"\n");
        glTexCoord($ff->[3], $ff->[4]);
        glVertex($ff->[0],$ff->[1],$ff->[2]);
        $ff = $f->[$i++];
	#print join (":",@$ff,"\n");
        glTexCoord($ff->[3], $ff->[4]);
        glVertex($ff->[0],$ff->[1],$ff->[2]);

        }

      glEnd();
      }

    if (scalar @{$self->{face_triangle_vertices}} > 0)
      {
      glBegin(GL_TRIANGLES);

      my $f = $self->{face_triangle_vertices};
      for ($i = 0; $i < @$f; $i += 3)
        {
        glTextCoord(0,0);
        glVertex(@{$f->[$i]});
        glTextCoord(1,0);
        glVertex(@{$f->[$i]});
        glTextCoord(0,1);
        glVertex(@{$f->[$i]});
        }

      glEnd();
      }

  #glPopMatrix();
  }

sub _render_portals
  {
  my $self = shift;
  }

sub render
  {
  # render the room plus all visible portals
  my ($self,$camera,$portals) = @_;

  my ($mark,$stack);
  # traverse the portal tree starting with this room
  push @$stack, $self;					# always do self
  $mark->{$self->{id}} = 1;
  $self->traverse($mark,$stack);

  foreach my $room (reverse @$stack)
    {
    #print "Rendering ",$room->id,"\n";
    $room->_render_faces();
    $room->_render_portals() if $portals;
    }

  }

1;

__END__

=pod

=head1 NAME

Room.pm - describes a "room" in portal-render (rooms are connectd by portals)

=head1 SYNOPSIS

	use Games::3D::Room;

	my $room_a = Games::3D::Room->new( );
	$room_a->add_faces( $face );
        ...

	my $room_b = Games::3D::Room->new( );
	$room_a->add_portals( { portal => $face, room => $room_b } );

	$room_a->render($camera,$with_portals);

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a class for representing a room for a portal renderer.

=head1 METHODS

It features all the methods of Games::3D::Area (namely: new(), _init(),
x(), y(), z(), width(), height(), length(), pos(), size() and pos()) plus:

=over 2

=item render()

	$room->render($camera);

Renders the room plus all visible portals (e.g. faces looking into other
rooms).

=item default_texture()

	$room->default_texture();
	$room->default_texture( $texture );

Get/set the default texture as OpenGL texture object. Also possible as
parameter to new().

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Area> as well as L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

