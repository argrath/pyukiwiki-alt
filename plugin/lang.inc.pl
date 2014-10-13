######################################################################
# lang.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: lang.inc.pl,v 1.21 2006/09/29 09:11:32 papu Exp $
#
# "PyukiWiki" version 0.1.7-rc3 $$
# Author: Nanami http://lineage.netgamers.jp/
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
# 言語cookie設定用プラグイン
# ExPlugin lang.inc.cgi、$::write_location=1を有効にする必要があります
######################################################################

sub plugin_lang_action {
	my $body;
	return if($::lang_cookie eq '' || $::write_location eq 0);

	my @http_headers=();
	push(@http_headers, "Status: 302");
	if($::form{refer} ne '') {
		push(@http_headers, "Location: $::basehref?@{[&encode($::form{refer})]}");
	} else {
		push(@http_headers, "Location: $::basehref?@{[&encode($::FrontPage)]}");
	}
	$::lang_cookie{lang}=$::form{lang};
	$::lang_cookie{lang}='' if($::langlist{$::form{lang}} eq '');
	&setcookie($::lang_cookie, 1, %::lang_cookie);
	print &http_header(
		@http_headers,
		$::HTTP_HEADER
		);
	close(STDOUT);
	exit;
}

1;
__END__

=head1 NAME

lang.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

This is explugin/lang.inc.cgi 's sub plugin, look explugin document.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/lang

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/ExPlugin/lang/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/lib/lang.inc.pl>

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/lang.inc.pl>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

=item PyukiWiki Developers Team

L<http://pyukiwiki.sourceforge.jp/>

=back

=head1 LICENSE

Copyright (C) 2005-2006 by Nanami.

Copyright (C) 2005-2006 by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 2 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
