use Test::More tests => 2;

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

unlink('t/testconfig');
