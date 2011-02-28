#!perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'Blog::Manager' ) || print "Bail out!
";
}

diag( "Testing Blog::Manager $Blog::Manager::VERSION, Perl $], $^X" );
