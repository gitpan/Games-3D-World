
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

sub cross
  {
  # cross-product between vectors (modifies first vector)
  my ($v,$w) = @_;

  my $v1 = $v->{x};
  my $v2 = $v->{y};
  my $v3 = $v->{z};
  my $w1 = $w->{x};
  my $w2 = $w->{y};
  my $w3 = $w->{z};

  $v->{x} = $v2 * $w3 - $v3 * $w2;
  $v->{y} = $v3 * $w1 - $v1 * $w3;
  $v->{z} = $v1 * $w2 - $v2 * $w1;

  $v;
  }

sub dot
  {
  # dot-product between vectors (return new scalar)
  my ($v,$w) = @_;

  $v->{x} * $w->{x} + $v->{y} * $w->{y} + $v->{z} * $w->{z};
  }

sub copy
  {
  # create a copy of the vector and return it
  my $self = shift;

  my $r = { x => $self->{x}, y => $self->{y}, z => $self->{z} };
  bless $r, ref($self);
  }

sub set
  {
  my $self = shift;

  ($self->{x}, $self->{y}, $self->{z}) = @_;
  }

sub mul
  {
  my ($self,$x,$y,$z) = @_;

  $self->{x} *= $x if $x;
  $self->{y} *= $y if $y;
  $self->{z} *= $z if $z;

  $self;
  }

sub add
  {
  my ($self,$other) = @_;

  $self->{x} += $other->{x};
  $self->{y} += $other->{y};
  $self->{z} += $other->{z};
  $self;
  }

sub subtract
  {
  my ($self,$other) = @_;

  $self->{x} -= $other->{x};
  $self->{y} -= $other->{y};
  $self->{z} -= $other->{z};
  $self;
  }

sub divide
  {
  my ($self,$factor) = @_;

  $self->{x} /= $factor;
  $self->{y} /= $factor;
  $self->{z} /= $factor;
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

=item copy()

	$vector_copy = $vector->copy();

Make a copy of the vector object and return it.

=item cross()

	$vector->cross($vector2);

Computes the cross product of C<$vector> and C<$vector2> and stores the result
in C<$vector>. If you want just the cross product without modifying the first
vector, use:

	$cross = $vector->copy()->cross($vector2);

=item dot()

	$dot = $vector->dot($vector2);

Computes the dot product of C<$vector> and C<$vector2> and returns the result
as a scalar.

=item set()

	$vector->set($x,$y,$z);

Set the vector to the three components.

=item add()

	$self->add($other);

Add another vector to the first one.

=item mul()

	$self->mul($x,$y,$z);

Multiply X,Y,Z components with C<$x>, C<$y>, C<$z>, respectively.

=item subtract()

	$self->subtract($other);

Subtract another vector from the first one.

=item divide()

	$self->divide($scalar);

Divide the vector by a scalar (can be seen as the inverse of scale);

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Point>, L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

