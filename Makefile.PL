use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Games::3D::World',
    'VERSION_FROM'	=> 'lib/Games/3D/World.pm', # finds $VERSION
    'PREREQ_PM'		=> {
			Games::3D => 0.02,
			Games::Object => 0.05,
			SDL::App::FPS => 0.20,
			SDL => '1.20.3', # see http://bloodgate.com/perl/sdl/
			}, # e.g., Module::Name => 1.1
    'LIBS'		=> [ ], # e.g., '-lm'
    'DEFINE'		=> '', # e.g., '-DHAVE_SOMETHING'
    'INC'		=> '', # e.g., '-I/usr/include/other'
);
