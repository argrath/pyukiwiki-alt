# release file perl script for pyukiwiki
# $Id: Jcode-convert.pl,v 1.23 2006/03/04 13:12:52 papu Exp $

BEGIN {
	push @INC, 'lib';
	push @INC, 'lib/CGI';
}

use Jcode;

$code=$ARGV[0];
$src=$ARGV[1];
$dest=$ARGV[2];

if(open(R,$src)) {
	foreach(<R>) {
		$buf.="$_";
	}
	close(R);
	&Jcode::convert($buf, $code);
	if(open(W,">$dest")) {
		print W $buf;
		close(W);
	} else {
		die "$dest can't write";
	}
} else {
	die "$src can't read";
}
