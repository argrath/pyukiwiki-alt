######################################################################
# alias.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: alias.inc.pl,v 1.14 2006/09/29 09:11:32 papu Exp $
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
# Based on PukiWiki Plugin "alias.inc.php" ver.1.5 2005/05/28
# modified by kochi
# http://221.243.18.83/~pukiwiki/index.php?%A5%D7%A5%E9%A5%B0%A5%A4%A5%F3%2Falias.inc.php
######################################################################

use strict;

$alias::loopmax=2;

%alias::loopcount;
@alias::pushmypage;

sub plugin_alias_convert {
;	# no param
	my($page,$usethispagetitle)=split(/,/, shift);
	return ' ' if($::form{mypage}=~/($::MenuBar|$::SideBar|$::Header|$::Footer)$/);
	return ' ' if($::form{cmd} ne 'read');
	return ' ' if($::form{noalias} eq 'true');
	return ' ' if($alias::loopcount{$::form{mypage}} > 0);
	$alias::loopcount{$::form{mypage}}++;
	$alias::loopcount{""}++;
	return ' ' if($alias::loopcount{""} >= $alias::loopmax);

	push(@alias::pushmypage,$::form{mypage});
	my $title=$::form{mypage};
	$::form{mypage}=$page;
	if($usethispagetitle eq 1) {
		&do_read($title);
	} else {
		&do_read;
	}
	&close_db;
	exit;
}

1;
__END__

=head1 NAME

alias.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #alias(pagename [,pagenameflag])

=head1 DESCRIPTION

It jumps to specified another Wiki page, without displaying a page.

=back

=head1 USAGE

=over 4

=item pagename

Specify wiki page. When the loop is carried out, an alias is ended at the time and the page in this time is displayed.

=item pagenameflag

If it specified 0, the page name of the alias point will be displayed.

If it specified 1, the page name of alias origin will be displayed. However, as for the link of edit etc., the page name of the alias point is specified.

=item other

In order to change the page of alias origin, please change by the ?cmd=adminedit&mypage=pagename.

=back

=head1 SETTING

=head2 alias.inc.pl

=over 4

=item $alias::loopmax

The number of times of the maximum of an alias is specified. A default is 2.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/alias

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/alias/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/alias.inc.pl>

=item PukiWiki alias.inc.php

L<http://221.243.18.83/~pukiwiki/index.php?%A5%D7%A5%E9%A5%B0%A5%A4%A5%F3%2Falias.inc.php>


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
