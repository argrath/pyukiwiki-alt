#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id: getversion.pl,v 1.27 2006/03/04 13:12:52 papu Exp $

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);
print "$::version";

