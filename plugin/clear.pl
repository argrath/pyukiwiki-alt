######################################################################
# clear.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: clear.pl,v 1.57 2006/09/29 09:11:32 papu Exp $
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

use strict;
package clear;

sub plugin_inline {
	return '<div class="clear"></div>';
}
1;

__END__

=head1 NAME

clear.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &clear;

=head1 DESCRIPTION

Disable a surroundings lump of a text

inserts a CSS class 'clear', to set 'clear:both'

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/clear

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/clear/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/clear.pl>

=back

=head1 AUTHOR

=over 4

=item Nanami

L<http://lineage.netgamers.jp/> etc...

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
