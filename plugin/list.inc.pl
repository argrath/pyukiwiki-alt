######################################################################
# list.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: list.inc.pl,v 1.57 2006/09/29 09:11:32 papu Exp $
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
# v0.2 non_list
# v0.1
######################################################################

sub plugin_list_action {
	my $navi = qq(<div id="body"><div id="top" style="text-align:center">);
	my $body = qq(</div>);
	my $prev = '';
	my $char = '';
	my $idx = 1;

	foreach my $page (sort keys %::database) {
		next if ($page =~ $::non_list);
		next unless(&is_readable($page));
		$char = substr($page, 0, 1);
		if (!($char =~ /[a-zA-Z0-9]/)) {
			$char = $::resource{list_plugin_otherchara};
		}
		if ($prev ne $char) {
			if ($prev ne '') {
				$navi .= " |\n";
				$body .= "  </ul>\n </li>\n</ul>\n";
			}
			$prev = $char;
			$navi .= qq(<a id="top_$idx" href="?cmd=list#head_$idx"><strong>$prev</strong></a>);
			$body .= <<"EOD";
<ul>
 <li><a id="head_$idx" href="?cmd=list#top_$idx"><strong>$prev</strong></a>
  <ul>
EOD
			$idx++;
		}
		$body .= qq(<li><a href="@{[&make_cookedurl(&encode($page))]}">@{[&escape($page)]}</a>@{[&escape(&get_subjectline($page))]}</li>\n);
	}
	$body .= qq(</li></ul>);

	return ('msg' => "\t$::resource{list_plugin_title}", 'body' => $navi . $body);
}
1;
__END__

=head1 NAME

list.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=list

=head1 DESCRIPTION

Display all page list.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/list

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/list/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/list.inc.pl>

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
