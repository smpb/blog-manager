use strict;
use warnings;
use ExtUtils::MakeMaker 6.3002;

WriteMakefile(
    NAME               => 'Blog::Manager',
    ABSTRACT           => 'A simple, extensible, plugin-based blog manager.',
    AUTHOR             => q{"Sérgio Bernardino" <"me@sergiobernardino.net">},
    VERSION_FROM       => 'lib/Blog/Manager.pm', # finds VERSION
    LICENSE            => 'perl',
    PREREQ_PM => {
        'Test::More'        => 0,
        'Module::Pluggable' => 0,
        'Log::Handler'      => 0,
        'JSON'              => 0,
        'WWW::Tumblr'       => 0,
    },
    dist               => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    test               => {
        'TESTS' => 't/*.t'
    }
);