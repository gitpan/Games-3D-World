
# This is just the version number and the documentation (for now)

package Games::3D::World;

# (C) by Tels <http://bloodgate.com/>

use strict;

use vars qw/$VERSION/;

use Games::3D::Level;

$VERSION = '0.03';

1;

__END__

=pod

=head1 NAME

Games::3D::World - 3d level, camera etc, that can be rendered with OpenGL

=head1 SYNOPSIS

	use Games::3D::World;

	my $world = Games::3D::World->new( file => 'level01.txt' );

	# set up camera
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

This package defines no methods yet.

=head1 BUGS

None known yet.

=head1 AUTHORS

(c) 2003, Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<SDL:App::FPS>, L<SDL::App> and L<SDL>.

L<GAME::3D::Vector>,  L<GAME::3D::Brush>,  L<GAME::3D::Level>.

=cut

