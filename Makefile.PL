use 5.008006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Net::Scan::SSH::Server::Version',
    VERSION_FROM      => 'lib/Net/Scan/SSH/Server/Version.pm',
    PREREQ_PM         => {
				Class::Accessor::Fast => 0.22,
			},

    ($] >= 5.005 ?
      (ABSTRACT       => 'A simple way to grab SSH server version.',
       AUTHOR         => 'Matteo Cantoni <mcantoni@cpan.org>') : ()),
);
