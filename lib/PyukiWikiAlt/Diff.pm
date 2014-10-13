package PyukiWikiAlt::Diff;

use strict;
use warnings;

my $nostring = qq(<span style="font-size: 70%;">[CR]</span>);


sub construct
{
    my (@body) = ();

    foreach (split(/\n/, &::htmlspecialchars($_[0]))) {
	my %x;
	
	if (/^\+(.*)/) {
	    $x{content} = qq(<b class="diff_added">$1@{[$1 eq '' ? "$nostring" : '']}</b>\n);
	} elsif (/^\-(.*)/) {
	    $x{content} = qq(<s class="diff_removed">$1@{[$1 eq '' ? "$nostring" : '']}</s>\n);
	} elsif (/^[= ](.*)/) {
	    $x{content} = qq(<span class="diff_same">$1</span>\n);
	} else {
	    $x{content} = qq|??? $_\n|;
	}
	push @body, \%x;
    }

    return \@body;
}

1;
