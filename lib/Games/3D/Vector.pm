
# Vector - a 3D vector (aka a vector from the origin to a point in 3D space)

package Games::3D::Vector;

# (C) by Tels <http://bloodgate.com/>

use strict;

use Exporter;
use Games::3D::Point;
use vars qw/@ISA $VERSION/;
@ISA = qw/Games::3D::Point Exporter/;

$VERSION = '0.02';

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  
  $args = { @_ } if @_ != 3;		# 3 elements => ->new($x,$y,$z)
  if (ref $args eq 'HASH')
    {
    $self->{x} = $args->{x} || 0;
    $self->{y} = $args->{y} || 0;
    $self->{z} = $args->{z} || 0;
    }
  else
    {
    $self->{x} = shift || 0;
    $self->{y} = shift || 0;
    $self->{z} = shift || 0;
    }

  $self;
  }

sub length
  {
  # return length of vector
  my $self = shift;

  sqrt(   $self->{x} * $self->{x} 
	+ $self->{y} * $self->{y}
	+ $self->{z} * $self->{z});
  }

sub scale
  {
  my ($self,$factor) = @_;

  $self->{x} *= $factor;
  $self->{y} *= $factor;
  $self->{z} *= $factor;

  $self;
  }

sub flip
  {
  my ($self) = @_;

  $self->{x} = -$self->{x};
  $self->{y} = -$self->{y};
  $self->{z} = -$self->{z};

  $self;
  }

sub translate
  {
  my ($self,$x,$y,$z) = @_;
  
  $self->{x} += $x if defined $x;
  $self->{y} += $y if defined $y;
  $self->{z} += $z if defined $z;

  $self;
  }

sub rotate
  {
  my ($self,$x,$y,$z) = @_;
 
  $self;
  }

sub normalize
  {
  my ($self) = @_;
 
  my $len = sqrt(   $self->{x} * $self->{x} 
		  + $self->{y} * $self->{y}
		  + $self->{z} * $self->{z});
  $self->{x} /= $len;
  $self->{y} /= $len;
  $self->{z} /= $len;

  $self;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Vector - a vector in 3D space

=head1 SYNOPSIS

	use Games::3D::Vector;

	my $vec = Games::3D::Vector->new( x => 1, y => 9, z => -1 );
	$vec->scale(5);
	$vec->normalize();
	print $vec->length();
	$vec->flip(5);		# same as scale(-1)

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for vectors in 3D space, including the
ability to manipulate (rotate, translate, scale, normalize) them.

=head1 METHODS

=over 2

=item new()

	my $vector = Games::3D::Vector->new( $arguments );

Creates a new vector. The arguments are the x,y and z components like:
	
	my $vector = Games::3D::Vector->new( x => 9, y => -8.1, z => -2);

=item id()

Return the vectors's unique id.

=item x()

	print $vector->x();
	$vector->x(123);
	
Set and return or just return the vector's X component.

=item y()

	print $vector->y();
	$vector->y(123);
	
Set and return or just return the vector's Y component.

=item z()

	print $vector->z();
	$vector->z(123);
	
Set and return or just return the vector's Z component.

=item pos()

	print join (" ", $vector->pos());
	$vector->pos(123,456,-1);		# set X,Y and Z
	$vector->pos(undef,undef,1);		# set only Z
	
Set and return or just return the vector's components.

=item length()

	$vector->length();

Returns the vectors length.

=item normalize()

	$vector->normalize();

Normalizes the length of the vector to C<1.0>.

=item scale()

	$vector->scale($factor);

Scales the vector by this factor.

=item flip()

	$vector->flip();

Makes the vector point backward, e.g. is equivalent to C<$vector->scale(-1);>.

=item translate()

	$vector->translate($x,$y,$z);

Translates the vector in X, Y and Z direction. Undef values are the same as 0,
e.g. leave that axis alone:
	
	$vector->translate(1,undef,2);

is the same as:

	$vecotr->translate(1,0,2);

=item rotate()

	$vector->rotate($xr,$yr,$zr);

Rotates the vector around the X, Y and Z axis (in that order). The arguments
are expected to be passed in radians.

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Point>, L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

