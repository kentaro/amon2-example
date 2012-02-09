package MyApp::Web::Root;
use strict;
use warnings;
use parent qw(MyApp::Web::Base);

sub index {
    my ($self, $c, $args) = @_;
    $c->render('index.tt');
}

!!1;
