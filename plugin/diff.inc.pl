######################################################################
# diff.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: diff.inc.pl,v 1.57 2006/09/29 09:11:32 papu Exp $
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
# v0.2 BugFix $diffbase -> $::diffbase Tnx! Mr.Yashigani-modoki.
# v0.1 Proto
######################################################################

$diff::nostring=qq(<span style="font-size: 70%;">[CR]</span>);

sub plugin_diff_action {
	if (not &is_editable($::form{mypage})) {
		&do_read;
		&close_db;
		exit;
	}
	&open_diff;
	my $title = $::form{mypage};
	$_ = &htmlspecialchars($::diffbase{$::form{mypage}});
	&close_diff;
	my $body = qq(<h3>$::resource{diff_plugin_msg}</h3>);
	$body .= qq($::resource{diff_plugin_notice});
	$body .= qq(<pre class="diff">);
	foreach (split(/\n/, $_)) {
		if (/^\+(.*)/) {
			$body .= qq(<b class="diff_added">$1@{[$1 eq '' ? "$diff::nostring" : '']}</b>\n);
		} elsif (/^\-(.*)/) {
			$body .= qq(<s class="diff_removed">$1@{[$1 eq '' ? "$diff::nostring" : '']}</s>\n);
		} elsif (/^\=(.*)/) {
			$body .= qq(<span class="diff_same">$1</span>\n);
		} else {
			$body .= qq|??? $_\n|;
		}
	}
	$body .= qq(</pre>);
	$body .= qq(<hr>);
	return ('msg' => "$title\t$::resource{diff_plugin_title}", 'body' => $body, 'ispage'=>1);
}
1;
__END__

=head1 NAME

diff.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=diff&mypage=pagename

=head1 DESCRIPTION

Display of difference of page and last backup state.

The page name must be encoded.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/diff

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/diff/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/diff.inc.pl>

=item YukiWiki

Using Yuki::DiffText

L<http://www.hyuki.com/yukiwiki/wiki.cgi>

=item CPAN Algorithm::Diff

L<http://search.cpan.org/dist/Algorithm-Diff/>

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
