use strict;
use warnings;
use ExtUtils::MakeMaker 6.3002;

WriteMakefile(
    NAME               => 'Blog::Manager',
    ABSTRACT           => 'A simple, extensible, plugin-based blog manager.',
    AUTHOR             => q{"Sérgio Bernardino" <me@sergiobernardino.net>},
    VERSION_FROM       => 'lib/Blog/Manager.pm', # finds VERSION
    LICENSE            => 'perl',

    PREREQ_PM   => {
        'Test::More'        => 0,
        'Module::Pluggable' => 0,
        'Log::Handler'      => 0,
        'JSON'              => 0,
        'XML::Simple'       => 0,
        'WWW::Tumblr'       => 4.2
    },

    META_MERGE  => {
        resources => {
          homepage     => 'http://github.com/smpb/blog-manager',
          repository   => 'git://github.com/smpb/blog-manager.git'
        }
    },
    
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    clean => { FILES    => 'Blog-Manager-*' },
    test  => { TESTS    => 't/*.t' }
);