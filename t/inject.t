use Test::More tests => 3;

use CPAN::Mini::Inject;
use File::Path;
use File::Copy;

rmtree( [ 't/local/MYCPAN/modulelist' ] ,0,1);
copy('t/local/CPAN/modules/02packages.details.txt.gz.bak','t/local/CPAN/modules/02packages.details.txt.gz');
rmtree( [ 't/local/CPAN/authors' ] ,0,1);
mkdir('t/local/MYCPAN');

my $mcpi;
my $module="S/SS/SSORICHE/CPAN-Mini-Inject-0.01.tar.gz";

$mcpi=CPAN::Mini::Inject->new;
$mcpi->loadcfg('t/.mcpani/config')
     ->parsecfg
     ->readlist
     ->add( module => 'CPAN::Mini::Inject', authorid => 'SSORICHE', version => '0.01', file => 't/local/mymodules/CPAN-Mini-Inject-0.01.tar.gz' )
     ->writelist;

ok($mcpi->inject,'Copy modules');
ok(-e "t/local/CPAN/authors/id/$module",'Module file exists');
ok(-e 't/local/CPAN/authors/id/S/SS/SSORICHE/CHECKSUMS','Checksum created');

unlink('t/local/CPAN/authors/id/S/SS/SSORICHE/CHECKSUMS');
unlink("t/local/CPAN/authors/id/$module");
unlink('t/local/MYCPAN/modulelist');
unlink('t/local/CPAN/modules/02packages.details.txt.gz');

rmtree( [ 't/local/CPAN/authors','t/local/MYCPAN' ] ,0,1);
