use strict;
use warnings;

use Plack::Builder;

use lib 'lib';
use lib glob 'modules/*/lib';

use MyApp::Web;

builder {
    enable 'Plack::Middleware::XFramework' => framework => 'Amon2';
    MyApp::Web->to_app;
};
