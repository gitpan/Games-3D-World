
# Attractor - a point where a distance-dependend force comes from

package Games::3D::Attractor;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Mass;
use Games::3D::Vector;
use vars qw/@ISA $VERSION @EXPORT_OK/;

@EXPORT_OK = qw/
  FORCE_INVARIANT
  FORCE_LINEAR
  FORCE_QUADRATIC
  /;
@ISA = qw/Games::3D::Mass Exporter/;

$VERSION = '0.01';

##############################################################################
# constants

# 0 - no distance dependency
use constant FORCE_INVARIANT => 0;

# 1 - linear distance dependency
use constant FORCE_LINEAR => 1;

# 2 - quadratic distance dependency
use constant FORCE_QUADRATIC => 2;

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->SUPER::_init($args);

  $self->{force} = $args->{force} || 0.1;
  $self->{type} = $args->{type} || FORCE_INVARIANT;
  $self->{attracts} = $args->{attracts} || 0x01;	# objects class 1

  $self;
  }

sub attract
  {
  # take a mass, and see if we attract it (if we apply a force to it)
  my ($self,$object) = @_;

  return unless (( $object->attracted_by() & $self->{attracts}) != 0);

  # object has set bit in bitfield indicating it is attracted by our type

  # calculate distance of our pos to the object's pos
  my $att_pos_vec = Games::3D::Vector->new($self->pos());
  my $obj_pos_vec = Games::3D::Vector->new($object->pos());

  my $dist_vec = $att_pos_vec->copy()->subtract( $obj_pos_vec );
  my $distance = $dist_vec->length();

  # calculate resulting force as scalar
  my $force;
  if ($self->{type} < 0)
    {
    # 1 / 2 ** 0 => 1 / 1  => 1
    # 1 / 2 ** 1 => 1 / 2  => 0.5
    # 1 / 2 ** 2 => 1 / 4  => 0.25
    # 1 / 4 ** 0 => 1 / 1  => 1
    # 1 / 4 ** 1 => 1 / 4  => 0.25
    # 1 / 4 ** 2 => 1 / 16 => 0.0625
    $force = $self->{force} / ($distance ** $self->{type});
    }
  else
    {
    # 1 * 2 ** 0 => 1 * 1  => 1
    # 1 * 2 ** 1 => 1 * 2  => 2
    # 1 * 2 ** 2 => 1 * 4  => 4
    # 1 / 4 ** 0 => 1 * 1  => 1
    # 1 / 4 ** 1 => 1 * 4  => 4
    # 1 / 4 ** 2 => 1 * 16 => 16
    $force = $self->{force} * ($distance ** -$self->{type});
    }

  # $force = 10* $self->{force} if $force > 10* $self->{force}; # max force cap
  
  # now calculate direction of force (from object in dir of attractor)

  $dist_vec->normalize()->scale($force); 

  # and apply it to the object
  $object->apply_force( $dist_vec);

  $self;
  }

sub type
  {
  my $self = shift;

  $self->{type} = $_[0] if @_ > 0;
  $self->{type};
  }

sub force
  {
  my $self = shift;

  $self->{force} = $_[0] if @_ > 0;
  $self->{force};
  }

1;

__END__

=pod

=head1 NAME

Games::3D::Mass - a physical mass with simulation and forces applied

=head1 SYNOPSIS

	use Games::3D::Mass;

	my $mass = Games::3D::Mass->new( mass => 123 );
	$mass->clear_force();
	$mass->apply_force( $vector );
	$mass->simulate();

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for massses in 3D space.

=head1 METHODS

It features all the methods of Games::3D::Point (namely: new(), _init(),
x(), y(), z() and pos()) plus:

=over 2

=item apply_force

=item clear_forces

=item force

=item speed

=item mass

=item simulate

=item update

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Area> as well as L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

