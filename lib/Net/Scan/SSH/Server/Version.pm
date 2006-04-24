package Net::Scan::SSH::Server::Version;

use 5.008006;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
use Carp;
use IO::Socket;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->mk_accessors( qw(host port timeout debug));

$| = 1;

sub scan {

	my $self    = shift;
	my $host    = $self->host;
	my $port    = $self->port    || 22;
	my $timeout = $self->timeout || 8;
	my $debug   = $self->debug   || 0;

	my $CRLF    = "\015\012";

	my $connect = IO::Socket::INET->new(
		PeerAddr => $host,
		PeerPort => $port,
		Proto    => 'tcp',
		Timeout  => $timeout
	);

	$SIG{ALRM}=sub{exit(0);};
	alarm $timeout;

	my $version;
 
	if ($connect){
	
		print $connect "$CRLF";
		
		my @lines = $connect->getlines(); 

		if (@lines){
			foreach (@lines){
				if ($_ =~ /^SSH/){
					$version = $_;
					chomp $version;
				}
			}
		}

		close $connect; 

		return $version if $version;	
	} else {
		if ($debug){
			return "connection refused";
		} else {
			return "";	
		}
	}
}

1;
__END__

=head1 NAME

Net::Scan::SSH::Server::Version - grab SSH server version 

=head1 SYNOPSIS

  use Net::Scan::SSH::Server::Version;

  my $host = $ARGV[0];

  my $scan = Net::Scan::SSH::Server::Version->new({
    host    => $host,
    timeout => 5
  });

  my $results = $scan->scan;

  print "$host $results\n" if $results;

=head1 DESCRIPTION

This module permit to grab SSH server version.

=head1 METHODS

=head2 new

The constructor. Given a host returns a L<Net::Scan::SSH::Server::Version> object:

  my $scan = Net::Scan::SSH::Server::Version->new({
    host    => '127.0.0.1',
    port    => 22,
    timeout => 5,
    debug   => 0 
  });

Optionally, you can also specify :

=over 2

=item B<port>

Remote port. Default is 22;

=item B<timeout>

Default is 8 seconds;

=item B<debug>

Set to 1 enable debug. Debug displays "connection refused" when an SSH server is unrecheable. Default is 0;

=back

=head2 scan 

Scan the target.

  $scan->scan;

=head1 BUGS

For this moment grab only "standard OpenSSH version".

=head1 SEE ALSO

L<http://www.OpenSSH.org>

=head1 AUTHOR

Matteo Cantoni, E<lt>mcantoni@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

You may distribute this module under the terms of the Artistic license.
See Copying file in the source distribution archive.

Copyright (c) 2006, Matteo Cantoni

=cut
