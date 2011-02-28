package Blog::Manager::Platform;

use warnings;
use strict;
use JSON;
use Log::Handler;
use Data::Dumper;

=head1 NAME

Blog::Manager::Platform - The great new Blog::Manager::Platform!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Blog::Manager::Platform;

    my $foo = Blog::Manager::Platform->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new
{
  my $class = shift;
  return $class if (ref $class );

  my $self = {};
  $self->{'_LOG'} = Log::Handler->get_logger("Blog::Manager");
  $self->{'_LOG'}->debug("$class - Initializing an instance.");

  # argument processing
  if (@_ % 2 == 0)
  {
    # upper-case (only) the hash keys
    my %args = @_;
    %args = map { uc $_ => $args{$_} } keys %args;

  }
  
  #

  bless($self, $class);
  return $self;
}

=head2 import

=cut

sub import
{
}

=head2 export

=cut

sub export
{
}

=head2 load_file

=cut

sub load_file
{
  my ($self, $filename) = @_;
  die "ERROR: can't invoke 'load_file' as a class method.\n" unless ref($self);

  open(FILE, $filename) or die "error opening '$filename': $!\n";
  my $json_posts = do { local $/; <FILE>; };
  $self->{'_POSTS'} = decode_json($json_posts);
  
  $self->{'_LOG'}->debug("$self - These were the posts loaded: " . Dumper($self->{'_POSTS'}));

  return (defined $self->{'_POSTS'}) ? 1 : 0;
}

=head1 AUTHOR

"Sergio Bernardino", C<< <"me at sergiobernardino.net"> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-blog-manage at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Blog-Manage>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Blog::Manager::Platform


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Blog-Manage>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Blog-Manage>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Blog-Manage>

=item * Search CPAN

L<http://search.cpan.org/dist/Blog-Manage/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 "Sergio Bernardino".

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Blog::Manager::Platform
