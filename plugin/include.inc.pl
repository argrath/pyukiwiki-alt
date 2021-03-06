######################################################################
# include.inc.pl - This is PyukiWiki, yet another Wiki clone.
# $Id: include.inc.pl,v 1.56 2006/09/29 09:11:32 papu Exp $
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

sub plugin_include_convert {
	my ($arg)=@_;
	my(@opt)=split(/,/,$arg);
	my $page = shift @opt;
	my $notitle=0;
	foreach(@opt) {
		$notitle=1 if(/notitle/);
	}
	if ($page eq '') { return ''; }
	my $body = '';
	if (&is_exist_page($page)) {
		if(&is_readable($page)) {
			my $rawcontent = $::database{$page};
			$body = &text_to_html($rawcontent, toc=>1);
			my $cookedpage = &encode($page);
			my $link = "<a href=\"$::script?$cookedpage\">$page</a>";
			if ($::form{mypage} eq $::MenuBar) {
				$body = <<"EOD";
<span align="center"><h5 class="side_label">$link</h5></span>
<small>$body</small>
EOD
			} else {
				if($notitle eq 0) {
					$body = "<h1>$link</h1>\n$body\n";
				}
			}
		} else {
			return ' ';
		}
	}
	return $body;
}
1;
__END__

=head1 NAME

include.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #include(wikipage[,notitle])

=head1 DESCRIPTION

Include WikiPage

=head1 USAGE

=over 4

=item notitle

Disable display page title of included page

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/include

L<http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Standard/include/>

=item PyukiWiki CVS

L<http://cvs.sourceforge.jp/cgi-bin/viewcvs.cgi/pyukiwiki/PyukiWiki-Devel/plugin/include.inc.pl>

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
