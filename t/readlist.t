use Test::More tests => 3;

use CPAN::Mini::Inject;
use File::Path;

rmtree( [ 't/local/MYCPAN/modulelist' ],0,1);
mkdir 't/local/MYCPAN';

my $mcpi;
$mcpi=CPAN::Mini::Inject->new;
$mcpi->loadcfg('t/.mcpani/config')
     ->parsecfg;

$mcpi->readlist;
is($mcpi->{modulelist},undef,'Empty module list');

genmodlist();


$mcpi=CPAN::Mini::Inject->new;
$mcpi->loadcfg('t/.mcpani/config')
     ->parsecfg
     ->readlist;

is(@{$mcpi->{modulelist}},3,'Read modulelist');

SKIP: {
  eval  { use Test::Exception };
  skip 'Test::Exception not installed', 1 if $@;
  skip 'User is superuser and can always read', 1 if $< == 0;

  $mcpi=CPAN::Mini::Inject->new;
  $mcpi->loadcfg('t/.mcpani/config_noread')
       ->parsecfg;
  dies_ok { $mcpi->readlist } 'unreadable file';
}
rmtree( [ 't/local/MYCPAN/modulelist' ],0,1);

sub genmodlist {
  open(MODLIST,'>t/local/MYCPAN/modulelist') or die "Can not create t/local/MYCPAN/modulelist: $!";
  print MODLIST << "EOF"
CPAN::Checksums                   1.016  A/AN/ANDK/CPAN-Checksums-1.016.tar.gz
CPAN::Mini                         0.18  R/RJ/RJBS/CPAN-Mini-0.18.tar.gz
CPANPLUS                         0.0499  A/AU/AUTRIJUS/CPANPLUS-0.0499.tar.gz
EOF
;
  close(MODLIST);
}
