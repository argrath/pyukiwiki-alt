######################################################################
# contents.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: contents.inc.pl,v 1.61 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: Nekyo
# Copyright (C) 2004-2006 by Nekyo.
# http://nekyo.hp.infoseek.co.jp/
# Copyright (C) 2005-2006 PyukiWiki Developers Team
# http://pyukiwiki.sourceforge.jp/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sourceforge.jp/
# License: GPL2 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return:LF Code=EUC-JP 1TAB=4Spaces
######################################################################
# v0.1.7 2006/05/26 #contents(¾�ڡ���) ��¾�ڡ����Υ���ƥ�Ĥ�ɽ��
#                   �Ǥ���褦�ѹ� ̵����λ��Ϥ��ޤޤ��̤�Ǥ���
# v0.1.6 2006/01/07 *****�ޤ��б�������¾����
# v0.0.2 2005/01/20 base �ˤ���������б�
# v0.0.1 �ץ��ȥ�����
######################################################################

use strict;

sub plugin_contents_convert {
	my ($parmpage)=shift;
	my $page;
	if ($parmpage ne '') {
		$page = $parmpage;
		$::pushedpage = $page;
	} else {
		$page = $::form{mypage};
	}

	my ($txt) = $::database{$page};
	my (@txt) = split(/\r?\n/, $txt);
	return &plugin_contents_main("", @txt);
}

sub plugin_contents_main {
	my $baseurl = shift;
	my @txt = @_;
	my $tocnum = 0;
	my (@tocsaved, @tocresult);
	my $title;
	my $nametag = &pageanchorname($::form{mypage});

	foreach (@txt) {
		chomp;
		if (/^(\*{1,5})(.+)/) {
			&back_push('ul', length($1), \@tocsaved, \@tocresult);
			$title = &inline($2);
			$title =~ s/<[^>]+>//g;
			if($baseurl eq '') {
				push(@tocresult, qq(<li><a href=")
					 . &make_cookedurl(&encode($::pushedpage eq '' ? $::form{mypage} : $::pushedpage))
					. qq(#$nametag$tocnum">$title</a></li>\n));
			} else {
				push(@tocresult, qq(<li><a href=")
					 . $baseurl
					. qq(#$nametag$tocnum">$title</a></li>\n));
			}
			$tocnum++;
		}
	}
	push(@tocresult, splice(@tocsaved));
	my $body = <<EOD;
<div class="contents">
<a id="contents_1"></a>
EOD
	$body .= join("\n", @tocresult) . "</div>\n";
	return $body;
}
1;
__END__

=head1 NAME

contents.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #contents
 #contents(page name)

=head1 DESCRIPTION

The list of the titles in the installed page is displayed.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/contents

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/contents/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/contents.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nekyo

L<http://nekyo.hp.infoseek.co.jp/>

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2004-2006 by Nekyo.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut