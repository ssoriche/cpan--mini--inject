use Test::More tests => 7;

use CPAN::Mini::Inject;
use File::Path;

mkdir('t/local/MYCPAN');

my $mcpi;
$mcpi=CPAN::Mini::Inject->new;
$mcpi->loadcfg('t/.mcpani/config')
     ->parsecfg;

$mcpi->add( module => 'CPAN::Mini::Inject', authorid => 'SSORICHE', version => '0.01', file => 't/local/mymodules/CPAN-Mini-Inject-0.01.tar.gz' );
is($mcpi->{authdir},'S/SS/SSORICHE','author directory');
ok(-r 't/local/MYCPAN/authors/id/S/SS/SSORICHE/CPAN-Mini-Inject-0.01.tar.gz','Added module is readable');
my $module="CPAN::Mini::Inject                 0.01  S/SS/SSORICHE/CPAN-Mini-Inject-0.01.tar.gz";
ok(grep(/$module/,@{$mcpi->{modulelist}}),'Module added to list');

# XXX do the same test as above again, but this time with a ->readlist after
# the ->parsecfg

SKIP: {
  eval "use Test::Exception";
  skip "Test::Exception not installed", 2 if $@;
  use Test::Exception;

  dies_ok { $mcpi->add( module => 'CPAN::Mini::Inject', authorid => 'SSORICHE', version => '0.01' ) } 'Missing add param';
  dies_ok { $mcpi->add( module => 'CPAN::Mini::Inject', authorid => 'SSORICHE', version => '0.01', file => 'blahblah' ) } 'Module file not readable';
}

SKIP: {
  eval "use Test::Exception";
  skip "Test::Exception not installed", 1 if $@;
  use Test::Exception;

  $mcpi->loadcfg('t/.mcpani/config_norepo')
       ->parsecfg;

  dies_ok { $mcpi->add( module => 'CPAN::Mini::Inject', authorid => 'SSORICHE', version => '0.01', file => 'test-0.01.tar.gz' ) } 'Missing config repository';
}

SKIP: {
  eval "use Test::Exception";
  skip "Test::Exception not installed", 1 if $@;
  use Test::Exception;

  $mcpi->loadcfg('t/.mcpani/config_read')
       ->parsecfg;

  dies_ok { $mcpi->add( module => 'CPAN::Mini::Inject', authorid => 'SSORICHE', version => '0.01', file => 'test-0.01.tar.gz' ) } 'read-only repository';
}

rmtree('t/local/MYCPAN',1,1);
