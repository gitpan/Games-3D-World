
# Mass - a physical mass, on which forces can be applied

package Games::3D::Mass;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;
use Games::3D::Point;
use Games::3D::Vector;
use vars qw/@ISA $VERSION/;

@ISA = qw/Games::3D::Point Exporter/;

$VERSION = '0.01';

##############################################################################
# methods

sub _init
  {
  # to be overwritten in subclasses
  my $self = shift;

  my $args = $_[0];
  $args = { @_ } unless ref $args eq 'HASH';

  $self->SUPER::_init($args);

  $self->{force} = Games::3D::Vector->new( 0,0,0);
  $self->{speed} = Games::3D::Vector->new( 0,0,0);		# not moving
  $self->{attracted_by} = abs($args->{attracted_by} || 1);	# bitfield
  $self->{friction} = abs($args->{friction} || 0.90);
  $self->{max_speed} = abs($args->{max_speed} || 10);		# mm/ms
  
  $self->{mass} = abs($args->{mass} || 1);
  # may not seem to make sense to have static masses, but subclasses may
  # want to disable physical updates via this
  $self->{static} = $args->{static} || 0;	

  $self->{pos_vec} = Games::3D::Vector->new( @{$self->{pos}} );	# as vector
  $self;
  }

sub clear_forces
  {
  my ($self) = @_;

  $self->{force}->set(0,0,0);
  }

sub update
  {
  my ($self,$time_diff) = @_;

  return if $self->{static};		# no forces act on us

  # if some force is acting on us
  if ($self->{force}->length != 0)
    {
    # vel += (force / m) * dt;
    $self->{speed}->add( $self->{force}->copy()->divide($self->{mass})->scale($time_diff) );
    if (abs($self->{speed}->length()) > $self->{max_speed})
      {
      my $factor = $self->{max_speed} / abs($self->{speed}->length());
      $self->{speed}->scale($factor);
      }
    # pos += vel * dt;
    $self->{pos_vec}->add ( $self->{speed}->copy()->scale( $time_diff) );
    ($self->{x}, 
    $self->{y} , 
    $self->{z} ) = 
      ( $self->{pos_vec}->{x}, $self->{pos_vec}->{y}, $self->{pos_vec}->{z} );
    }
  # thats not right yet
  $self->{speed}->scale($self->{friction});
  }

sub apply_force
  {
  my $self = shift;

  $self->{force}->add(shift);
  $self;
  }

sub force
  {
  my $self = shift;

  $self->{force};
  }

sub speed
  {
  my $self = shift;

  $self->{speed};
  }

sub mass
  {
  my $self = shift;

  $self->{mass} = abs(shift || 1) if @_ > 0;
  $self->{mass};
  }

sub attracted_by
  {
  my $self = shift;

  $self->{attracted_by} = abs(shift || 1) if @_ > 0;
  $self->{attracted_by};
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

