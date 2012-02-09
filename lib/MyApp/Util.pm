package MyApp::Util;
use strict;
use warnings;

use Class::Load qw(load_class);

use MyApp::Config;
sub root () { MyApp::Config->root }

!!1;
