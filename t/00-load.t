#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Blog::Manage' ) || print "Bail out!
";
}

diag( "Testing Blog::Manage $Blog::Manage::VERSION, Perl $], $^X" );
