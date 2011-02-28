package Blog::Manager::Tumblr;

use warnings;
use strict;
use Log::Handler;
use WWW::Tumblr;
use Data::Dumper;

=head1 NAME

Blog::Manager::Tumblr - The great new Blog::Manager::Tumblr!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
our @ISA = qw(Blog::Manager::Platform);

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Blog::Manager::Tumblr;

    my $foo = Blog::Manager::Tumblr->new();
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

  my $self = $class->SUPER::new(@_);

  if ($self)
  {
    # specific argument processing
    if (@_ % 2 == 0)
    {
      # upper-case (only) the hash keys
      my %args = @_;
      %args = map { uc $_ => $args{$_} } keys %args;

      $self->{'_LOG'}->debug("$class - A new Tumblr manager was requested with these args: " . Dumper(\%args));

      $self->{'_CONNECTION'} = WWW::Tumblr->new;

      $self->{'_CONNECTION'}->email($args{'USERNAME'}) if (defined $args{'USERNAME'});
      $self->{'_CONNECTION'}->password($args{'PASSWORD'}) if (defined $args{'PASSWORD'});
      $self->{'_CONNECTION'}->url($args{'URL'}) if (defined $args{'URL'});

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

=head2 url

=cut

sub url
{
  my ($self, $url) = @_;
  return unless (ref($self));

  return $self->{'_CONNECTION'}->url($url);
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

=head1 AUTHOR

"Sergio Bernardino", C<< <"me at sergiobernardino.net"> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-blog-manage at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Blog-Manage>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Blog::Manager::Tumblr


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

1; # End of Blog::Manager::Tumblr
