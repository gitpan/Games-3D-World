
# Level - a class containing one level (loaded from a file)

package Games::3D::Level;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Brush qw/BRUSH_AIR/;
use Games::3D::Thingy;
use Games::Resource;
use vars qw/@ISA $VERSION/;

use Games::3D::Room;

@ISA = qw/Games::3D::Thingy Exporter/;

$VERSION = '0.03';

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->{brushs} = [ ];

  $self->{rooms} = [ ];

  $self->_load( $args->{file} ) if $args->{file};
  $self->_build_portals();
  $self;
  }

sub add_brush
  {
  my ($self,$brush) = @_;

  push @{$self->{brushs}}, $brush;
  }

sub render
  {
  my $self = shift;
  
  # XXX TODO
  # hack, simple start with room 0
  #$self->{rooms}->[0]->render() if ref($self->{rooms}->[0]);
  
  foreach my $room (@{$self->{rooms}})
    {
    # print "Rendering room ",$room->id(),"\n";
    $room->render();
    }
  }

sub brushes
  {
  my $self = shift;

  scalar @{$self->{brushs}};
  }

sub rooms
  {
  my $self = shift;

  scalar @{$self->{rooms}};
  }

sub _build_portals
  {
  my $self = shift;
  # from the read-in (or generated) list of brushes, build a list of rooms
  # linked by portals, this is what we later render

  foreach my $brush (@{$self->{brushs}})
    {
    next if $brush->type() ne BRUSH_AIR;
    my $room =
      Games::3D::Room->new( default_texture => $brush->{default_texture} );
    my $faces = $brush->faces();
    $room->add_faces(@$faces);
    push @{$self->{rooms}}, $room;
    }
  }

sub _load
  {
  # load a level from a file
  my ($self,$file) = @_;

  my $fh = Games::Resource::open($file);
 
  die ("Cannot load level '$file': $!") unless ref $fh;
  my $txt = $fh->contents();

  print "Loaded level $file\n";
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Level - a class containing one level (loaded from a file)

=head1 SYNOPSIS

	use Games::3D::Level;

	my $level = Games::3D::Level->new( file => 'filename' );
	$level->render();

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for shapes/areas in 3D space.

=head1 METHODS

It features all the methods of Games::3D::Point (namely: new(), _init(),
x(), y(), z() and pos()) plus:

=over 2

=item width()

	print $area->width();
	$area->width(123);
	
Set and return or just return the area's width (size along the X axis).

=item length()

	print $area->length();
	$area->length(123);
	
Set and return or just return the area's length (size along the Y axis).

=item height()

	print $area->height();
	$area->height(123);
	
Set and return or just return the area's height (size along the Z axis).

=item brushes()

	print $level->brushes();

Return the number of brushes inside the level.

=item rooms()

	print $level->rooms();

Return the number of rooms inside the level.

=item render()

	$level->render();

Renders the level by rendering all the portals.

=item _load()

	$level->load($file);

Load a level from a file. Called automatically by new().

=item _build_portals()

	$level->_build_portals();

After L<_load()>, the portals are build to prepare the level for rendering.

=item size()

	print join (" ", $area->size());
	$area->size(123,456,-1);		# set X,Y and Z
	$area->size(undef,undef,1);		# set only Z
	
Set and return or just return the area's size along the three axes.

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Area> as well as L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

