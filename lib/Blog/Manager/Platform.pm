package Blog::Manager::Platform;

use warnings;
use strict;
use JSON;
use Log::Handler;
use Data::Dumper;

=head1 NAME

Blog::Manager::Platform - Generic blog platform to manage

=head1 SYNOPSIS



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
  
  #

  bless($self, $class);
  return $self;
}

=head2 write_post

=cut

sub write_post {}

=head2 edit_post

=cut

sub edit_post {}

=head2 delete_post

=cut

sub delete_post {}

=head2 read_posts

=cut

sub read_posts {}

=head2 import

=cut

sub import {}

=head2 export

=cut

sub export {}

=head2 load_file

=cut

sub load_file
{
  my ($self, $filename) = @_;
  return unless ref($self);

  if (defined $filename)
  {
    my $fh;
    $self->{'_POSTS_FILE'} = $filename;

    unless(open($fh, '<', $filename))
    {
      $self->{'_LOG'}->error("$self - error opening '$filename': $!");
      return;
    }

    my $json_posts = do { local $/ = undef; <$fh>; };
    close($fh);

    $self->{'_POSTS'} = decode_json($json_posts);  
    $self->{'_LOG'}->debug("$self - These were the posts loaded: " . Dumper($self->{'_POSTS'}));

    return (defined $self->{'_POSTS'}) ? 1 : 0;
  }
  else
  {
    return $self->{'_POSTS_FILE'};
  }
}

=head1 AUTHOR

"Sérgio Bernardino", E<lt>me@sergiobernardino.netE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2011 "Sérgio Bernardino"

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Blog::Manager::Platform
