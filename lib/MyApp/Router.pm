package MyApp::Router;
use strict;
use warnings;
use parent qw(Exporter);

our @EXPORT    = qw(route);
our @EXPORT_OK = @EXPORT;

use MyApp::Util;

use Router::Simple;
my $router = Router::Simple->new;
sub router () { $router }

sub route ($$) {
    my ($src, $dist) = @_;

    # ex: route '/' => 'Root#index'
    if (@_ == 2 && !ref $_[1]) {
        my ($path, $dest_str) = @_;
        my ($controller, $action) = split('#', $dest_str);
        my %dest;

        $dest{controller} = $controller;
        $dest{action}     = $action if defined $action;

        $router->connect($path, \%dest);
    }

    # ex: route '/' => { controller => 'Root', action => 'index' }
    else {
        $router->connect(@_);
    }
}

my %CLASS_LOADED;
sub dispatch {
    my ($class, $c) = @_;
    my $req = $c->request;

    if (my $matched = $router->match($req->env)) {
        my $type       = $ENV{MYAPP_WEB} ? 'Web' : 'CLI';
        my $controller = sprintf 'MyApp::%s::%s', $type, $matched->{controller};
        my $action     = $matched->{action};

        $CLASS_LOADED{$controller} //= do {
            MyApp::Util::load_class($controller);
            $controller;
        };

        $c->{args} = $matched;
        $controller->new->$action($c, $matched);
    }
    else {
        $c->res_404();
    }
}

!!1;
