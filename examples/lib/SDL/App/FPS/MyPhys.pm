
# example of SDL::App::FPS demonstrating usage of Physical Simulation

package SDL::App::FPS::MyPhys;

# (C) 2003 by Tels <http://bloodgate.com/>

use strict;

use SDL::OpenGL;
use SDL::OpenGL::Cube;
use SDL::App::FPS qw/
  BUTTON_MOUSE_LEFT
  BUTTON_MOUSE_MIDDLE
  BUTTON_MOUSE_RIGHT
  /;
use SDL::Event;

use vars qw/@ISA/;
@ISA = qw/SDL::App::FPS/;

use Games::OpenGL::Font::2D qw/FONT_ALIGN_RIGHT FONT_ALIGN_BOTTOM/;
use Games::3D::PhysEng qw/PI/;
use Games::3D::World;
use Games::3D::Attractor qw/ FORCE_INVARIANT FORCE_LINEAR FORCE_QUADRATIC/;
use Games::3D::Mass;

##############################################################################

sub _gl_draw_cube
  {
  my $self = shift;

  # compute the current angle based on elapsed time
  my $angle = ($self->current_time() / 5) % 360;
  my $other = ($self->current_time() / 7) % 360;

  glRotate($angle,1,1,0);
  glRotate($other,0,1,1);

  $self->{cube}->draw();
  }
  
sub _gl_pre_draw
  {
  glClear( GL_DEPTH_BUFFER_BIT() | GL_COLOR_BUFFER_BIT());
  glMatrixMode(GL_MODELVIEW());
  glLoadIdentity();
  glTranslate(0,0,-76.0);
  glDisable( GL_TEXTURE_2D );

  }

sub _move_attractor
  {
  my ($self,$att,$current_time) = @_;

  # move the attractor around
 
  my $f = 360 / (2*PI);
 
  # compute the current pos based on elapsed time
  my $x = (($current_time / 17) % 360) / $f;
  my $y = (($current_time / 9) % 360) / $f;
  my $z = (($current_time / 17) % 360) / $f;

  $x = 9 * sin($x);
  $y = 7 * cos($y);
  $z = 3 * cos($z);
  
  $att->pos($x,$y,$z);
  }

sub _gl_draw_objects
  {
  my $self = shift;
  my $current_time = shift;

  # draw objects
  my $i = 0;
  for my $obj (@{$self->{attractors}}, @{$self->{objects}})
    {
    next if (0 == 
         ($self->{colors}->[0] + $self->{colors}->[1] + $self->{colors}->[2]));
    glColor( @{$self->{colors}->[$i]} );
    glMatrixMode(GL_MODELVIEW());
    glLoadIdentity();
    glTranslate(0,0,-76.0);
    glTranslate($obj->pos());
    $self->_gl_draw_cube();
    $i++;
    }
  }

sub _gl_init_view
  {
  my $self = shift;

  glViewport(0,0,$self->width(),$self->height());

  glMatrixMode(GL_PROJECTION());
  glLoadIdentity();

  glFrustum(-0.1,0.1,-0.075,0.075,0.3,200.0);

  glMatrixMode(GL_MODELVIEW());
  glLoadIdentity();
  
  glEnable(GL_CULL_FACE);
  glFrontFace(GL_CCW);
  glCullFace(GL_BACK);

  foreach my $f (qw/font/)
    {
    $self->{$f}->screen_width( $self->width() );
    $self->{$f}->screen_height( $self->height() );
    }
  $self->{width} = $self->width();
  $self->{height} = $self->height();
  }

sub draw_frame
  {
  # draw one frame, usually overrriden in a subclass.
  my ($self,$current_time,$lastframe_time,$current_fps) = @_;

  # using pause() would be a bit more efficient, though 
  return if $self->time_is_frozen();
  
  my @main = @{$self->{attractors}};
  foreach my $att (@main)
    {
    $self->_move_attractor($att,$current_time);
    }

  $self->{engine}->update($current_time);
  $self->_gl_pre_draw();
  $self->_gl_draw_objects();

  $self->{font}->pre_output();
  $self->{font}->output (5, $self->height() - 30, 
	sprintf("%3i",scalar @{$self->{objects}}) . " objects" );
  $self->{font}->post_output();

  }

sub resize_handler
  {
  my $self = shift;

  $self->_gl_init_view();
  }

sub post_init_handler
  {
  my $self = shift;

  print "Constructing font...";
  $self->{font} = Games::OpenGL::Font::2D->new( 
     file => 'data/courier.bmp',
     chars => 256-32,
     chars_per_line => 16,
     char_width => 11,
     char_height => 21,
     zoom_y => 0.75,
     );
  print "done.\n";
  
  $self->_gl_init_view();

  $self->{cube} = SDL::OpenGL::Cube->new();

  my @colors =  (
        1.0,1.0,0.0,    1.0,0.0,0.0,    0.0,1.0,0.0, 0.0,0.0,1.0,       #back
        0.4,0.4,0.4,    0.3,0.3,0.3,    0.2,0.2,0.2, 0.1,0.1,0.1 );     #front

  #$self->{cube}->color(@colors);

  # set up the physical simulation
  $self->{engine} = Games::3D::PhysEng->new( min_dt => 80 );

  # add attractor(s)
  $self->{attractors} = [];
  # main attractor (swarm follows this one)
  push @{$self->{attractors}}, Games::3D::Attractor->new( 
     type => FORCE_QUADRATIC, force => 0.122 );
  
  # detractor, detracts the objects from the main path
  #push @{$self->{attractors}}, Games::3D::Attractor->new( 
  #   type => FORCE_LINEAR, force => -0.05 );

  # register them with the engine
  foreach my $att (@{$self->{attractors}})
    {
    $self->{engine}->add_attractor($att);
    }
    
  # attractors are blue
  $self->{colors} = [ [ 0,0,1] ];
  
  # add masses
  $self->{objects} = [];
  for (1..16)
    {
    my $mass = Games::3D::Mass->new( 
      mass => rand(500) + 100, 
      x => 9 * rand() - 4.5, y => 7 * rand() - 3.5, z => 3 * rand() - 1.5,
      max_speed => 0.09, friction => 0.95 );
    push @{$self->{objects}}, $mass; 
    push @{$self->{colors}}, [ 0.5 + rand() / 2, rand() / 2, rand() / 2 ];
    $self->{engine}->add_mass($mass);
    }

  # set up some event handlers
  #$self->watch_event ( 
  #  quit => SDLK_q, fullscreen => SDLK_F1, freeze => SDLK_SPACE,
  #  screenshot => SDLK_PRINT,
  # );

  $self->add_event_handler (SDL_MOUSEBUTTONDOWN, BUTTON_MOUSE_LEFT,
   sub {
     my $self = shift;
     return if $self->time_is_ramping() || $self->time_is_frozen();
     $self->ramp_time_warp('2',1500);           # ramp up
     });
  $self->add_event_handler (SDL_MOUSEBUTTONDOWN, BUTTON_MOUSE_RIGHT,
   sub {
     my $self = shift;
     return if $self->time_is_ramping() || $self->time_is_frozen();
     $self->ramp_time_warp('0.2',2500);         # ramp down
     });
  $self->add_event_handler (SDL_MOUSEBUTTONDOWN, BUTTON_MOUSE_MIDDLE,
   sub {
     my $self = shift;
     return if $self->time_is_ramping() || $self->time_is_frozen();
     $self->ramp_time_warp('1',1500);           # ramp to normal
     });

  $self->{force_type} = 0;
  
  $self->{timer_sub} = sub {
     $self->{force_type} = 1-$self->{force_type};
     if ($self->{force_type} == 0)
       {
       $self->{attractors}->[0]->type(- FORCE_INVARIANT);
       $self->{attractors}->[0]->force(0.07);
       $self->add_timer ( 1000, 1, 0, 200, $self->{timer_sub} );
       }
     else
       {
       $self->{attractors}->[0]->type(FORCE_LINEAR);
       $self->{attractors}->[0]->force(-0.062);
       $self->add_timer ( 400, 1, 0, 150, $self->{timer_sub} );
       }
     };
  $self->add_timer ( 500, 1, 0, 200, $self->{timer_sub}); 
  }

1;

__END__

