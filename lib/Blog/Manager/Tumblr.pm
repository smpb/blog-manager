package Blog::Manager::Tumblr;

use base qw(Blog::Manager::Platform);
use warnings;
use strict;
use XML::Simple;
use Data::Dumper;
use Log::Handler;
use WWW::Tumblr 4.2;

=head1 NAME

Blog::Manager::Tumblr - Plugin for managing blogs on the Tumblr platform

=head1 SYNOPSIS



=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new
{
  my $class = shift;
  return $class if (ref $class );

  my $self = $class->SUPER::new(@_);

  if ($self)
  {
    $self->{'_GENERATOR'} = 'Blog::Manager::Tumblr - A Perl module // sergiobernardino.net';
    $self->{'_XML_PARSER'} = XML::Simple->new;

    # specific argument processing
    if (@_ % 2 == 0)
    {
      # normalization: upper-case (only) the hash keys
      my %args = @_;
      %args = map { uc $_ => $args{$_} } keys %args;

      $self->{'_LOG'}->debug("$class - A new Tumblr manager was requested with these args: " . Dumper(\%args));

      $self->{'_CONNECTION'} = WWW::Tumblr->new;

      $self->username($args{'USERNAME'}) if (defined $args{'USERNAME'});
      $self->password($args{'PASSWORD'}) if (defined $args{'PASSWORD'});
      $self->url($args{'URL'}) if (defined $args{'URL'});
      $self->load_file($args{'FILE'})  if (defined $args{'FILE'});
    }
  }

  unless ($self->{'_CONNECTION'}->authenticate)
  {
    $self->{'_LOG'}->error("$class - Unable to authenticate with Tumblr. Please check your credentials.");
    return;
  }

  #

  return $self;
}

=head2 username

=cut

sub username
{
  my ($self, $username) = @_;
  return unless (ref($self));

  if (defined $username)
  {
    $self->{'_URL'} = $username;
    return $self->{'_CONNECTION'}->email($username);
  }
  else
  {
    return $self->{'_USERNAME'};
  }
}

=head2 password

=cut

sub password
{
  my ($self, $password) = @_;
  return unless (ref($self));

  if (defined $password)
  {
    $self->{'_PASSWORD'} = $password;
    return $self->{'_CONNECTION'}->password($password);
  }
  else
  {
    return $self->{'_PASSWORD'};
  }
}

=head2 url

=cut

sub url
{
  my ($self, $url) = @_;
  return unless (ref($self));

  if (defined $url)
  {
    $self->{'_LOG'}->debug("$self - Tumblr URL: " . $url);
    $self->{'_URL'} = $url;
    return $self->{'_CONNECTION'}->url($url);
  }
  else
  {
    return $self->{'_URL'};
  }
}

=head2 write_post

=cut

sub write_post
{
  my ($self, $post) = @_;
  return unless (ref($self));

  # normalization: lower-case (only) the hash keys
  foreach (keys %{$post}) { $post->{lc $_ } = delete $post->{$_}; }

  unless (defined $post->{'type'})
  {
    $self->{'_LOG'}->error("$self - Unable to write the post: No type.");
    return;
  }
  
  my $ok;

  if    (lc($post->{'type'}) eq 'regular')      { $ok = $self->_validate_regular($post); }
  elsif (lc($post->{'type'}) eq 'photo')        { $ok = $self->_validate_photo($post);   }
  elsif (lc($post->{'type'}) eq 'quote')        { $ok = $self->_validate_quote($post);   }
  elsif (lc($post->{'type'}) eq 'link')         { $ok = $self->_validate_link($post);    }
  elsif (lc($post->{'type'}) eq 'conversation') { $ok = $self->_validate_conv($post);    }
  elsif (lc($post->{'type'}) eq 'video')        { $ok = $self->_validate_video($post);   }
  elsif (lc($post->{'type'}) eq 'audio')        { $ok = $self->_validate_audio($post);   }
  else
  {
    $self->{'_LOG'}->error("$self - Unable to write the post: Unknown type.");
    return;
  }

  if (defined $post->{'data'})
  {
    unless (-e $post->{'data'})
    {
      $self->{'_LOG'}->warning("$self - Data file specified for post does not exist.");
    }
  }
  
  if ($ok)
  {
    $post->{'generator'} = $self->{'_GENERATOR'};
    $post->{'group'} = $self->url if $self->url;
    return $self->{'_CONNECTION'}->write(%$post);
  }
  
  return;
}

sub _validate_regular
{
  my ($self, $post) = @_;
  return unless (ref $self);
  
  unless (defined $post->{'title'})
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'regular' post: No title defined.");
    return;
  }
  
  # ok
  return 1;
}

sub _validate_photo
{
  my ($self, $post) = @_;
  return unless (ref $self);
  
  unless ((defined $post->{'source'}) or (defined $post->{'data'}))
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'photo' post: No image source, or data file, defined.");
    return;
  }

  # ok
  return 1;
}

sub _validate_quote
{
  my ($self, $post) = @_;
  return unless (ref $self);

  unless (defined $post->{'quote'})
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'quote' post: No quote.");
    return;
  }

  # ok
  return 1;
}

sub _validate_link
{
  my ($self, $post) = @_;
  return unless (ref $self);

  unless (defined $post->{'url'})
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'link' post: No URL defined.");
    return;
  }

  # ok
  return 1;
}

sub _validate_conv
{
  my ($self, $post) = @_;
  return unless (ref $self);

  unless (defined $post->{'conversation'})
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'conversation' post: No conversation defined.");
    return;
  }

  # ok
  return 1;
}

sub _validate_video
{
  my ($self, $post) = @_;
  return unless (ref $self);

  unless ((defined $post->{'embed'}) or (defined $post->{'data'}))
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'video' post: No embedding code, or data file, defined.");
    return;
  }

  # ok
  return 1;
}

sub _validate_audio
{
  my ($self, $post) = @_;
  return unless (ref $self);

  unless ((defined $post->{'externaly-hosted-url'}) or (defined $post->{'data'}))
  {
    $self->{'_LOG'}->error("$self - Unable to write a 'video' post: No external URL, or data file, defined.");
    return;
  }

  # ok
  return 1;
}

=head2 edit_post

=cut

sub edit_post
{
  my ($self, $post_id, $post) = @_;
  return unless (ref $self);

  unless (defined $post_id)
  {
    $self->{'_LOG'}->error("$self - Unable to edit a post: No post ID defined.");
    return;
  }
  
  unless ((defined $post) and (ref($post) eq 'HASH'))
  {
    $self->{'_LOG'}->error("$self - Unable to edit a post: No new post contents defined.");
    return;
  }
  
  $post->{'post-id'} = $post_id;
  return $self->write_post($post);
}

=head2 delete_post

=cut

sub delete_post
{
  my ($self, $post_id) = @_;
  return unless (ref $self);

  unless (defined $post_id)
  {
    $self->{'_LOG'}->error("$self - Unable to delete a post: No post ID defined.");
    return;
  }

  return $self->{'_CONNECTION'}->delete('post-id', $post_id);
}

sub read_pages
{
  my ($self, $args) = @_;
  return unless (ref $self);

  return $self->{'_XML_PARSER'}->XMLin($self->{'_CONNECTION'}->pages(%$args));
}

sub read_posts
{
  my ($self, $args) = @_;
  return unless (ref $self);

  my $posts = $self->{'_XML_PARSER'}->XMLin($self->{'_CONNECTION'}->read(%$args));
  return $self->_normalize_responses($posts); 
}

sub read_liked_posts
{
  my ($self, $args) = @_;
  return unless (ref $self);

  my $posts = $self->{'_XML_PARSER'}->XMLin($self->{'_CONNECTION'}->likes(%$args));
  return $self->_normalize_responses($posts);
}

sub like_post
{
  my ($self, $post_id, $reblog_key) = @_;
  return unless (ref $self);

  unless (defined $post_id)
  {
    $self->{'_LOG'}->error("$self - Unable to like a post: No post ID defined.");
    return;
  }
  
  unless (defined $reblog_key)
  {
    $self->{'_LOG'}->error("$self - Unable to like a post: No reblog key defined.");
    return;
  }

  return $self->{'_CONNECTION'}->like('post-id', $post_id, 'reblog-key', $reblog_key);
}

sub unlike_post
{
  my ($self, $post_id, $reblog_key) = @_;
  return unless (ref $self);

  unless (defined $post_id)
  {
    $self->{'_LOG'}->error("$self - Unable to unlike a post: No post ID defined.");
    return;
  }

  unless (defined $reblog_key)
  {
    $self->{'_LOG'}->error("$self - Unable to unlike a post: No reblog key defined.");
    return;
  }

  return $self->{'_CONNECTION'}->unlike('post-id', $post_id, 'reblog-key', $reblog_key);
}

sub reblog_post
{
  my ($self, $post_id, $reblog_key, $args) = @_;
  return unless (ref $self);

  unless (defined $post_id)
  {
    $self->{'_LOG'}->error("$self - Unable to like a post: No post ID defined.");
    return;
  }
  
  unless (defined $reblog_key)
  {
    $self->{'_LOG'}->error("$self - Unable to like a post: No reblog key defined.");
    return;
  }

  $args->{'post-id'} = $post_id;
  $args->{'reblog-key'} = $reblog_key;
  $args->{'group'} = $self->url if $self->url;
  return $self->{'_CONNECTION'}->reblog(%$args);
}

=head2 import

=cut

sub import
{
  my $self = shift;
  return unless (ref $self);
}

=head2 export

=cut

sub export
{
  my $self = shift;
  return unless (ref $self);
}

# _normalize_responses
#
# The output from the Tumblr API is inconsistent.
#
# For example:
# The data structure varies depending on if it contains one post, or several.
#
# I don't like this at all, thus, this method eliminates these discrepancies.

sub _normalize_responses
{
  my ($self, $response) = @_;
  return unless (ref $self);
  return unless (defined $response and ref $response eq 'HASH');

  my $clean_response = {};
  
  foreach my $key (keys %$response)
  {
    # lets fix the posts output
    if ($key eq 'posts')
    {
      $clean_response->{'posts'} = [];

      # do we have the struct of only one post?
      if (defined $response->{'posts'}->{'post'}->{'id'})
      {
        push(@{$clean_response->{'posts'}}, $response->{'posts'}->{'post'});
      }
      else # the struct has more than one post
      {
        foreach my $id (sort keys %{$response->{'posts'}->{'post'}})
        {
          my $post = $response->{'posts'}->{'post'}->{$id};
          $post->{'id'} = $id;
          push(@{$clean_response->{'posts'}}, $post);
        }
      }
    }
    else
    {
      $clean_response->{$key} = $response->{$key};
    }
  }
  
  # done
  return $clean_response;
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

1; # End of Blog::Manager::Tumblr
