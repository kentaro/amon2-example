package MyApp::Web;
use strict;
use warnings;
use parent qw(MyApp Amon2::Web);

BEGIN { $ENV{MYAPP_WEB} = 1 }

use MyApp::Util;
use MyApp::Request;
use MyApp::Response;

use MyApp::Router;
use MyApp::Config::Route;

# CSRFがどうのとかは入れといた方がいいでしょう
__PACKAGE__->load_plugins(qw());

__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ($c, $res) = @_;

        $res->header('X-Content-Type-Options' => 'nosniff');
        $res->header('X-Frame-Options' => 'DENY');
        $res->header('Cache-Control' => 'private');
    },
);

__PACKAGE__->add_trigger(
    BEFORE_DISPATCH => sub {
        my ($c) = @_;
    },
);

# Amon2 hook points
sub create_request  { MyApp::Request->new($_[1]) }
sub create_response { shift; MyApp::Response->new(@_) }
sub dispatch { MyApp::Router->dispatch($_[0]) or die "response is not generated" }

use Text::Xslate;

my $view_conf = __PACKAGE__->config->{'view'} || {};

if (!exists $view_conf->{path}) {
    $view_conf->{path} = MyApp::Util->root->subdir('templates')->stringify;
}

my $view = Text::Xslate->new({
    syntax   => 'TTerse',
    module   => [ 'Text::Xslate::Bridge::Star' ],
    function => {
        c        => sub { Amon2->context()                    },
        uri_with => sub { Amon2->context()->req->uri_with(@_) },
        uri_for  => sub { Amon2->context()->uri_for(@_)       },
    },

    %$view_conf
});

sub create_view { $view }

!!1;
