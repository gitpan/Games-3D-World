
# Level - a class containing one level (loaded from a file)

package Games::3D::Level;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Brush qw/BRUSH_CUBE BRUSH_WEDGE/;
use Games::3D::Thingy;
use vars qw/@ISA $VERSION/;

@ISA = qw/Games::3D::Thingy Exporter/;

$VERSION = '0.02';

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->{brushs} = [ ];
  $self->{render} = [ ];

  $self;
  }

sub add_brush
  {
  my ($self,$brush) = @_;

  push @{$self->{brushs}}, $brush;
  push @{$self->{render}}, $brush;
  }

sub render
  {
  my $self = shift;

  foreach my $brush (@{$self->{render}})
    {
    # print "Rendering brush ",$brush->id(),"\n";
    $brush->render();
    }
  }

sub brushes
  {
  my $self = shift;

  scalar @{$self->{brushs}};
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

