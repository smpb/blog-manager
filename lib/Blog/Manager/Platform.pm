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

=head2 read_file

=cut

sub read_file
{
  my ($self, $filename) = @_;
  return unless ref($self);
  return unless defined $filename;

  my $fh;

  unless(open($fh, '<', $filename))
  {
    $self->{'_LOG'}->error("$self - error opening '$filename': $!");
    return;
  }

  my $json_posts = do { local $/ = undef; <$fh>; };
  close($fh);

  return decode_json($json_posts);  
}

=head2 write_file

=cut

sub write_file
{
  my ($self, $posts, $filename) = @_;
  return unless ref($self);
  return unless defined $posts;
  return unless defined $filename;

  my $fh;
  
  unless(open($fh, '>', $filename))
  {
    $self->{'_LOG'}->error("$self - error opening '$filename': $!");
    return;
  }

  my $json_posts = encode_json($posts);
  print $fh $json_posts;
  close($fh);

  return $json_posts;
}

# interface

sub write_post  {}
sub edit_post   {}
sub delete_post {}
sub read_posts  {}
sub import      {}
sub export      {}

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
