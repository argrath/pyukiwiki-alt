######################################################################
# source.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: source.inc.pl,v 1.3 2006/09/29 09:11:32 papu Exp $
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
######################################################################
# Usage:?cmd=source&page=pagename
######################################################################

use strict;
sub plugin_source_action {
	return if ($::form{'page'} eq '');
	my $page = $::form{'page'};
	print "Content-Type: text/plain\r\n\r\n";
	print $::database{$page};
	&close_db;
	exit(0);
}
1;
__END__

