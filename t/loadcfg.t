use Test::More tests => 4;

use CPAN::Mini::Inject;
use Env;

sub chkcfg {
  return 1 if(-r '/usr/local/etc/mcpani');
  return 1 if(-r '/etc/mcpani');
}

my $prevhome;
if(defined($ENV{HOME})) {
  $prevhome=$ENV{HOME};
  delete $ENV{HOME};
}

my $mcpanienv;
if(defined($ENV{MCPANI_CONFIG})) {
  $mcpanienv=$ENV{MCPANI_CONFIG};
  delete $ENV{MCPANI_CONFIG};
}

my $mcpi=CPAN::Mini::Inject->new;
SKIP: {
  skip 'Config file exists', 1 if(chkcfg());

  eval "use Test::Exception";
  skip 'Test::Exception not installed',1 if $@;
  use Test::Exception;

  dies_ok {$mcpi->loadcfg} 'No config file';
}

$mcpi->loadcfg('t/.mcpani/config');
is($mcpi->{cfgfile},'t/.mcpani/config');

$ENV{HOME}='t';
$mcpi->loadcfg;
is($mcpi->{cfgfile},'t/.mcpani/config');

$ENV{MCPANI_CONFIG}='t/.mcpani/config_mcpi';
$mcpi->loadcfg;
is($mcpi->{cfgfile},'t/.mcpani/config_mcpi');

# XXX add tests for /usr/local/etc/mcpani and /etc/minicpani

$ENV{MCPANI_CONFIG}=$mcpanienv if(defined($mcpanienv));
$ENV{HOME}=$prevhome if(defined($prevhome));
