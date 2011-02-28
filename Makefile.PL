use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Blog::Manager',
    AUTHOR              => q{"Sérgio Bernardino" <"me@sergiobernardino.net">},
    VERSION_FROM        => 'lib/Blog/Manager.pm',
    ABSTRACT_FROM       => 'lib/Blog/Manager.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Blog-Manager-*' },
);
