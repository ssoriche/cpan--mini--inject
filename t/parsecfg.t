use Test::More tests => 4;

use CPAN::Mini::Inject;

my $mcpi=CPAN::Mini::Inject->new;
$mcpi->loadcfg('t/.mcpani/config');
$mcpi->parsecfg;
is($mcpi->{config}{local},'t/local/CPAN');
is($mcpi->{config}{remote},'http://www.cpan.org');
is($mcpi->{config}{repository},'t/local/MYCPAN');

SKIP: {
  eval { use Test::Exception };
  skip "Test::Exception not installed", 2 if $@;
  use Test::Exception;

  $mcpi->loadcfg('t/.mcpani/config_bad');
  dies_ok {$mcpi->parsecfg} 'Missing config option';
}
