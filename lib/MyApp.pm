package MyApp;
use strict;
use warnings;
use parent qw(Amon2);

our $VERSION = '0.01';

# Amon2#configは使わない
use MyApp::Config;
sub load_config { MyApp::Config->current }
sub config      { MyApp::Config->current }

!!1;
