
# PhysEng - a physics simulation involvinf masses, forces etc

package Games::3D::PhysEng;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Thingy;
use Games::3D::Mass;
use Games::3D::Vector;
use vars qw/@ISA $VERSION @EXPORT_OK/;

@ISA = qw/Games::3D::Thingy Exporter/;
@EXPORT_OK = qw/PI/;
$VERSION = '0.01';

use constant PI => 3.141592654;

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->SUPER::_init($args);

  $self->{min_dt} = $args->{min_dt} || 40;
  $self->{masses} = [];
  $self->{attractors} = [];
  $self->{global_forces} = [];
  $self->{global_force} = Games::3D::Vector->new();
  $self->{last_time} = 0;

  $self;
  }

sub _clear_forces
  {
  # clear all the forces on all masses
  my ($self) = @_;

  foreach my $mass (@{$self->{masses}})
    {
    $mass->clear_forces();
    }
  }

sub add_global_force
  {
  my ($self,$force) = @_;

  # add one more 
  push @{$self->{global_forces}}, $force;

  $self->{global_force}->add($force);
  }

sub add_mass
  {
  my $self = shift;

  # add one or more masses
  push @{$self->{masses}}, @_;
  $self;
  }

sub add_attractor
  {
  my $self = shift;

  # add one or more more 
  push @{$self->{attractors}}, @_;
  $self;
  }

sub _apply_global_force
  {
  # this applies the global force (actually, the sum of all global forces) to
  # each mass
  my ($self) = @_;

  # if we have a non-zero global force
  if ($self->{global_force}->length != 0)
    {
    foreach my $mass (@{$self->{masses}})
      {
      $mass->add_force($self->{global_force});
      }
    }
  }

sub _apply_attractors
  {
  # this applies the attractors to each mass
  my ($self) = @_;

  foreach my $att (@{$self->{attractors}})
    {
    foreach my $mass (@{$self->{masses}})
      {
      $att->attract($mass);
      }
    }
  }

sub _collision_detection
  {
  my $self = shift;

  $self;
  }

sub _simulate
  {
  my ($self,$time_diff) = @_;
  
  my $iterations = int($time_diff / $self->{min_dt});
  my $left_over = $time_diff % $self->{min_dt};
  for (my $i = 0; $i < $iterations; $i++)
    {
    foreach my $mass (@{$self->{masses}})
      {
      $mass->update($self->{min_dt});
      }
    $self->_collision_detection();
    }
  # catch up to current frame, otherwise physics get out of sync
  foreach my $mass (@{$self->{masses}})
    {
    $mass->update($left_over);
    }
  $self->_collision_detection();
  $self;
  }

sub update
  {
  my $self = shift;
  my $current_time = shift;

  $self->_clear_forces();
  $self->_apply_global_force();
  $self->_apply_attractors();
  $self->_simulate($current_time - $self->{last_time})
    if ($self->{last_time} != 0);		# avoid long catch-up at start
  $self->{last_time} = $current_time;
  }

1;

__END__

=pod

=head1 NAME

Games::3D::PhysEng - a physical engine simulating masses and forces

=head1 SYNOPSIS

	use Games::3D::PhysEng;

	my $mass = Games::3D::Mass->new( mass => 123 );
	my $force = Games::3D::Vector->new(0, -9.81, 0);  # gravity pulls down
	my $engine = Games::3D::PhysEng->new( min_dt => 100, );

	$engine->add_mass($mass);
	$engine->add_global_force($force);

	# in each frame	
	$engine->update($current_time);

=head1 EXPORTS

Exports nothing on default.

=head1 DESCRIPTION

This package provides a base class for simulating masses and forces in 3D
space.

=head1 METHODS

=over 2

=item update

	$engine->update($current_time);

Update the positions and velocities of the objects to reflect the stand at the
current time.

=item add_mass

	$engine->add_mass( $mass );

Add one Games::3D::Mass object to the simulation.

=item add_global_force

	$engine->add_global_force( $force );

Add one force (as a Games::3D::Vector object), that will act on B<all>
objects in the simulation.

=item add_attractor

	$engine->add_attractor( $attractor );

Add one force (as a Games::3D::Attractor object), that will act on B<some>
objects in the simulation.

=back

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Games::3D::Vector>, L<Games::3D::Mass>, L<Games::3D::Area> as well as
L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

=cut

