package MyApp::Config;
use strict;
use warnings;

use Config::ENV MYAPP_ENV => default => 'default';

use Path::Class qw(file);
my $root = file(__FILE__)->dir->parent->parent;
sub root { $root }

common +{
    title => 'MyApp',
    view  => {},
};

# ここに環境変数ごとのdsnとかを書く
config default     => +{};
config test        => +{};
config development => +{};
config production  => +{};

!!1;
