use Test::More tests => 3;

use CPAN::Mini::Inject;
use lib 't/lib';
use LocalServer;

sub writecfg {
  my $remote=shift;
  open(CFGFILE,'>t/testconfig');
  print CFGFILE "remote: $remote\n";
  print CFGFILE "local: t/local/CPAN\n";
  print CFGFILE "repository: t/local/MYCPAN\n";
  close(CFGFILE);
}

my $server=LocalServer->spawn(file => 't/read/authors/01mailrc.txt.gz');

writecfg($server->url);

my $mcpi=CPAN::Mini::Inject->new;
$mcpi->loadcfg('t/testconfig')
     ->parsecfg;

$mcpi->testremote;
is($mcpi->{site},$server->url);

writecfg("http://blahblah   ".$server->url);

$mcpi->loadcfg('t/testconfig')
     ->parsecfg;

$mcpi->testremote;
is($mcpi->{site},$server->url);

$server->stop;

SKIP: {
  eval "use Test::Exception";
  skip 'Test::Exception not installed', 1 if $@;
  use Test::Exception;

  $mcpi->{config}{remote}="ftp://blahblah http://blah blah";
  dies_ok { $mcpi->testremote } 'No reachable site';
}

unlink('t/testconfig');
