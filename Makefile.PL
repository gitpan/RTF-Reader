use ExtUtils::MakeMaker;
 
&WriteMakefile(
           NAME           => 'RTF::Reader',
           DISTNAME       => 'RTF-Reader',
           VERSION_FROM   => 'lib/RTF/Reader.pm', 
           PREREQ_PM      => { 
             'Test::More' => '0.01',
						 'Class::Accessor' => '0.01'
           }               
);
