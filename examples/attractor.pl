#!/usr/bin/perl -w

# physical simulation: attractor and attracted objects

use strict;

BEGIN
  {
  $| = 1;
  unshift @INC, './lib';
  unshift @INC, '../lib';
  unshift @INC, '../blib/arch/';
  }

use SDL::App::FPS::MyPhys;

print
  "OpenGL Attractor Demo v0.01 (C) 2003 by Tels <http://Bloodgate.com/>\n\n";

print "Mouse buttons for speed changes, 'PRINT' for screenshot,\n";
print "'SPACE' for pause, 'F1' for fullscreen and 'q' for quit.\n";

my $app = SDL::App::FPS::MyPhys->new( { config => 'config/attractor.cfg' } );
$app->main_loop();

print "Running time was ", int($app->now() / 10)/100, " seconds\n";
print "Minimum framerate ",int($app->min_fps()*10)/10,
      " fps, maximum framerate ",int($app->max_fps()*10)/10," fps\n";
print "Minimum time per frame ", $app->min_frame_time(),
      " ms, maximum time per frame ", $app->max_frame_time()," ms\n";
print "Thank you for playing!\n";
