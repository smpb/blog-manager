package Blog::Manager;

use warnings;
use strict;
use Blog::Manager::Platform;
use Module::Pluggable require => 1, search_path => ['Blog::Manager'], except => 'Blog::Manager::Platform';
use Log::Handler;
use Data::Dumper;

=head1 NAME

Blog::Manager - A simple, extensible, plugin-based blog manager 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS



=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new
{
  my $class = shift;
  return $class if (ref $class);

  my $self = {};
  my $options = {
                  log_to     => 'STDERR',
                  maxlevel   => 'info',
                  minlevel   => 'error',
                  timeformat => "%d/%m/%Y %H:%M:%S",
  };

  $options->{'maxlevel'} = 'debug' if ($ENV{DEBUG});

  $self->{'_LOG'} = Log::Handler->create_logger('Blog::Manager');
  $self->{'_LOG'}->add(screen => $options); # default LOG

  bless($self, $class);

  # argument processing
  if (@_ % 2 == 0)
  {
    # normalization: upper-case (only) the hash keys
    my %args = @_;
    %args = map { uc $_ => $args{$_} } keys %args;    

    $self->{'_LOG'}->debug("$class - A new manager factory was requested."); 
  
    if (defined $args{'LOGFILE'})
    {
      delete($options->{'log_to'}); # we don't want this anymore
      $options->{'filename'} = $args{'LOG_FILE'};
      $self->{'_LOG'}->reload; # remove the 'screen LOG'
      $self->{'_LOG'}->add(file => $options);
      delete($args{'LOG_FILE'}); # we don't need this anymore
    }
  }
  else
  {
    $self->{'_LOG'}->error("$class - Invalid arguments list for instantiation.");
    return;
  }

  #

  return $self;
}

=head2 new

=cut

sub get_manager
{
  my $self = shift;
  unless (ref $self ) { $self = Blog::Manager->new; }

  # argument processing
  if (@_ % 2 == 0)
  {
    # upper-case (only) the hash keys
    my %args = @_;
    %args = map { uc $_ => $args{$_} } keys %args;     
  
    unless (defined $args{'TYPE'})
    {
      $self->{'_LOG'}->error("$self - Can't continue. No type of blog platform defined.");
      return;
    }

    $self->{'_LOG'}->debug("$self - A new manager was requested with these args: " . Dumper(\%args));
    
    # cycle plugins in search of the right one
    foreach my $plugin ($self->plugins)
    {
      $args{'TYPE'} = uc($args{'TYPE'});
      if (uc($plugin) =~ m/$args{'TYPE'}$/)
      {
        delete($args{'TYPE'}); # I don't want this as an argument passed to the plugin
        $self->{'_LOG'}->debug("$self - Found the correct plugin. It's $plugin.");
        if (my $manager = $plugin->new(%args))
        {
          $self->{'_LOG'}->debug("$self - We have an instance of the plugin: " . Dumper($manager));
          return $manager;
        }
        else
        {
          $self->{'_LOG'}->error("$self - Unable to create an instance for the manager.");
          return $manager;
        }
      }
    }  
  }
  else
  {
    $self->{'_LOG'}->error("$self - Invalid arguments list for instantiation.");
    return;
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

1; # End of Blog::Manager
