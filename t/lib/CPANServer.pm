package CPANServer;

use strict;
use warnings;
use HTTP::Server::Simple;
use File::Spec::Functions;

our @ISA=qw( HTTP::Server::Simple );

sub handle_request {
  my $self=shift;
  my $cgi=shift;

  my $file=(split('/',$cgi->path_info))[-1];
  open(INFILE,catfile('t','html',$file)) or die "Can't open file $file: $@";
  print $_ while(<INFILE>);
  close(INFILE);
}

1;
